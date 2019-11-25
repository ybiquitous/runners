module Runners
  class Workspace
    class DownloadError < SystemError; end

    attr_reader :options, :working_dir, :trace_writer

    # @param options [Runners::Options]
    # @param working_dir [Pathname]
    # @param trace_writer [Runners::TraceWriter]
    def initialize(options:, working_dir:, trace_writer:)
      @options = options
      @working_dir = working_dir
      @trace_writer = trace_writer
    end

    # @yieldparam git_ssh_path [Pathname, nil]
    # @yieldparam changes [Runners::Changes]
    def open
      prepare_ssh do |git_ssh_path|
        Dir.mktmpdir do |base_dir|
          base_path = Pathname(base_dir)
          Dir.mktmpdir do |head_dir|
            head_path = Pathname(head_dir)

            trace_writer.header "Setting up source code"

            base = options.base
            if base
              prepare_in_dir(:base, base, options.base_key, base_path)
            end
            prepare_in_dir(:head, options.head, options.head_key, head_path)

            trace_writer.message "Copying head to working dir..." do
              FileUtils.copy_entry(head_path, working_dir)
            end

            changes = trace_writer.message "Calculating changes between head and base..." do
              Changes.calculate(base_dir: base_path, head_dir: head_path, working_dir: working_dir)
            end

            yield git_ssh_path, changes
          end
        end
      end
    end

    private

    def prepare_ssh
      ssh_key = options.ssh_key
      if ssh_key
        Dir.mktmpdir do |dir|
          trace_writer.message "Preparing SSH config..."

          config_path = Pathname(dir) / 'config'
          key_path = Pathname(dir) / 'key'
          script_path = Pathname(dir) / 'run.sh'

          config_path.write(<<~SSH_CONFIG, perm: 0600)
            Host *
              CheckHostIP no
              ConnectTimeout 30
              StrictHostKeyChecking no
              IdentitiesOnly yes
              IdentityFile #{key_path}
          SSH_CONFIG
          key_path.write(ssh_key, perm: 0600)
          script_path.write(<<~GIT_SSH, perm: 0700)
            #!/bin/sh
            ssh -F #{config_path} "$@"
          GIT_SSH
          yield script_path
        end
      else
        trace_writer.message "Nothing to do"
        yield nil
      end
    end

    def prepare_in_dir(type, source, key, dir)
      trace_writer.message "Preparing #{type} commit tree..."

      uri = URI.parse(source)
      case uri.scheme
      when "http", "https"
        # When OpenSSL::Cipher::CipherError, probably the downloading is failed.
        # So retry downloading and decrypting
        Retryable.retryable(
          tries: 5,
          on: [OpenSSL::Cipher::CipherError, OpenSSL::SSL::SSLError, DownloadError, Net::OpenTimeout, Errno::ECONNRESET, SocketError, Net::HTTPForbidden],
          sleep: method(:retryable_sleep),
          exception_cb: -> (_ex) { trace_writer.message "Retrying download..." }
        ) do
          ::Tempfile.open do |io|
            trace_writer.message "Downloading source code..." do
              download(uri) do |response|
                response.read_body do |chunk|
                  io.write(chunk)
                end
              end
              io.flush
            end

            decrypt(Pathname(io.path), key) do |archive_path|
              extract(archive_path, dir)
            end
          end
        end
      when nil, "file"
        path = Pathname(uri.path).realpath

        case
        when path.directory?
          trace_writer.message "Copying source code..." do
            FileUtils.copy_entry(path, dir)
          end
        when path.file?
          decrypt(path, key) do |archive_path|
            extract(archive_path, dir)
          end
        else
          raise "Given non directory nor archive: #{path}"
        end

      else
        raise "Unexpected URI schema: #{uri}"
      end
    end

    def decrypt(archive, key)
      Dir.mktmpdir do |tmpdir|
        tmppath = Pathname(tmpdir)

        if key
          decrypted_path = tmppath.join(SecureRandom.uuid)

          trace_writer.message "Encryption key is given; decrypting..." do
            decrypt_by_openssl(archive, key, decrypted_path)
          end

          yield decrypted_path
        else
          yield archive
        end
      end
    end

    def decrypt_by_openssl(archive, password, out_path)
      dec = OpenSSL::Cipher.new("AES-256-CBC")
      dec.decrypt
      archive.open do |f|
        salt = f.read(dec.iv_len).force_encoding('ASCII-8BIT')[8, dec.iv_len]
        dec.pkcs5_keyivgen(password, salt, 1, 'md5')

        out_path.open('w') do |out|
          while data = f.read(100_000_000)&.force_encoding('ASCII-8BIT')
            out.write(dec.update(data))
          end
          out.write(dec.final)
        end
      end
    end

    def extract(archive, dir)
      trace_writer.message "Extracting archive to directory..." do
        out, status = Open3.capture2e("tar", "xf", archive.to_s, chdir: dir)
        raise "Extracting archive failed - #{out}" unless status.success?
      end
    end

    def download(uri, &block)
      Net::HTTP.get_response(uri) do |response|
        case response.code
        when /^2/
          yield response
        when "301", "302"
          download(URI.parse(response['location']), &block)
        else
          raise DownloadError, "Download is failed. #{response.inspect}"
        end
      end
    end

    def retryable_sleep(n)
      n + 1
    end
  end
end
