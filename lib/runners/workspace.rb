require 'openssl'
require 'retryable'

module Runners
  class Workspace
    class DownloadError < StandardError; end

    # @dynamic working_dir, base_dir, head_dir, git_ssh_path
    attr_reader :working_dir
    attr_reader :base_dir
    attr_reader :head_dir
    attr_reader :git_ssh_path

    def initialize(working_dir:, head_dir:, base_dir:, git_ssh_path:)
      @working_dir = working_dir
      @base_dir = base_dir
      @head_dir = head_dir
      @git_ssh_path = git_ssh_path
    end

    def calculate_changes
      Changes.calculate(base_dir: base_dir, head_dir: head_dir, working_dir: working_dir)
    end

    def self.open(base:, base_key:, head:, head_key:, ssh_key:, working_dir:, trace_writer:)
      prepare_ssh(ssh_key, trace_writer: trace_writer) do |ssh_path|
        Dir.mktmpdir do |base_dir|
          base_path = Pathname(base_dir)
          Dir.mktmpdir do |head_dir|
            head_path = Pathname(head_dir)

            trace_writer.header "Setting up source code"

            prepare_in_dir(:base, base, base_key, base_path, trace_writer: trace_writer) if base
            prepare_in_dir(:head, head, head_key, head_path, trace_writer: trace_writer)

            trace_writer.message "Copying head to working dir..." do
              FileUtils.copy_entry(head_path, working_dir)
            end

            yield new(working_dir: working_dir, base_dir: base_path, head_dir: head_path, git_ssh_path: ssh_path)
          end
        end
      end
    end

    def self.prepare_ssh(ssh_key, trace_writer:)
      trace_writer.header "Setting up SSH config"

      if ssh_key || ssh_key_content
        Dir.mktmpdir do |ssh_dir|
          trace_writer.message "Preparing SSH config..."

          config_path = ssh_dir + "/config"
          key_path = ssh_dir + "/key"
          git_ssh_path = ssh_dir + "/run.sh"

          File.write(config_path, <<~SSH_CONFIG)
            Host *
              CheckHostIP no
              ConnectTimeout 30
              StrictHostKeyChecking no
              IdentitiesOnly yes
              IdentityFile #{key_path}
          SSH_CONFIG
          File.write(key_path, ssh_key_content, perm: 0600) if ssh_key_content
          FileUtils.install(ssh_key, key_path, mode: 0600) if ssh_key
          File.write(git_ssh_path, <<~GIT_SSH)
            #!/bin/sh
            ssh -F #{config_path} "$@"
          GIT_SSH
          File.chmod(0755, git_ssh_path)

          yield git_ssh_path
        end
      else
        trace_writer.message "Nothing to do"
        yield nil
      end
    end

    def self.prepare_in_dir(type, source, key, dir, trace_writer:)
      trace_writer.message "Preparing #{type}..."

      uri = URI.parse(source)
      case uri.scheme
      when "http", "https"
        # When OpenSSL::Cipher::CipherError, probably the downloading is failed.
        # So retry downloading and decrypting
        Retryable.retryable(
          tries: 5,
          on: [OpenSSL::Cipher::CipherError, OpenSSL::SSL::SSLError, DownloadError, Net::OpenTimeout, Errno::ECONNRESET, SocketError, Net::HTTPForbidden],
          sleep: -> (n) { n + 1 },
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

            decrypt(Pathname(io.path), key, trace_writer: trace_writer) do |archive_path|
              extract(archive_path, dir, trace_writer: trace_writer)
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
          decrypt(path, key, trace_writer: trace_writer) do |archive_path|
            extract(archive_path, dir, trace_writer: trace_writer)
          end
        else
          raise "Given non directory nor archive: #{path}"
        end

      else
        raise "Unexpected URI schema: #{uri}"
      end
    end

    def self.decrypt(archive, key, trace_writer:)
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

    def self.decrypt_by_openssl(archive, password, out_path)
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

    def self.extract(archive, dir, trace_writer:)
      trace_writer.message "Extracting archive to directory..." do
        out, status = Open3.capture2e("tar", "xf", archive.to_s, chdir: dir)
        raise "Extracting archive failed - #{out}" unless status.success?
      end
    end

    def self.download(uri, &block)
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

    def self.ssh_key_content
      @ssh_key_content ||= ENV['BASE64_SSH_KEY'].presence&.yield_self { |value| Base64.decode64(value) }
    end
  end
end
