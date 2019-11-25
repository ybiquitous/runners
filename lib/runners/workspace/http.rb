module Runners
  class Workspace::HTTP < Workspace
    private

    def prepare_base_source(dest)
      base = archive_source.base
      if base
        provision(URI.parse(base), dest, archive_source.base_key)
      else
        raise "base must not be nil"
      end
    end

    def prepare_head_source(dest)
      provision(URI.parse(archive_source.head), dest, archive_source.head_key)
    end

    # @param uri [URI]
    # @param dest [Pathname]
    # @param key [String, nil]
    def provision(uri, dest, key)
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
            extract(archive_path, dest)
          end
        end
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
