module Runners
  class Workspace::File < Workspace
    private

    def prepare_base_source(dest)
      base = archive_source.base
      if base
        provision(Pathname(URI.parse(base).path).realpath, dest, archive_source.base_key)
      else
        raise ArgumentError, "base must not be nil"
      end
    end

    def prepare_head_source(dest)
      provision(Pathname(URI.parse(archive_source.head).path).realpath, dest, archive_source.head_key)
    end

    # @param src [Pathname]
    # @param dest [Pathname]
    # @param key [String, nil]
    def provision(src, dest, key)
      case
      when src.directory?
        trace_writer.message "Copying source code..." do
          FileUtils.copy_entry(src, dest)
        end
      when src.file?
        decrypt(src, key) do |archive_path|
          extract(archive_path, dest)
        end
      else
        raise "The specified path #{src} is neither directory nor file"
      end
    end
  end
end
