module NodeHarness
  class Changes
    class ChangedFile
      # @dynamic path
      attr_reader :path

      def initialize(path:)
        @path = path
      end

      def ==(other)
        other.is_a?(ChangedFile) && other.path == path
      end

      def eql?(other)
        self == other
      end

      def hash
        path.hash
      end
    end

    # @dynamic changed_files, unchanged_paths, untracked_paths
    attr_reader :changed_files
    attr_reader :unchanged_paths
    attr_reader :untracked_paths

    def initialize(changed_files:, unchanged_paths:, untracked_paths:)
      @changed_files = changed_files
      @unchanged_paths = unchanged_paths
      @untracked_paths = untracked_paths
    end

    def ==(other)
      other.is_a?(Changes) &&
        other.changed_files == changed_files &&
        other.unchanged_paths == unchanged_paths &&
        other.untracked_paths == untracked_paths
    end

    def delete_unchanged(dir:, except: [], only: [])
      # @type var files_to_delete: Array<Pathname>
      files_to_delete = []

      unchanged_paths.each do |path|
        if only.empty? || only.any? {|pattern| File.fnmatch(pattern, path.to_s, File::FNM_DOTMATCH) }
          if except.none? {|pattern| File.fnmatch(pattern, path.to_s, File::FNM_DOTMATCH) }
            file = dir + path
            if file.file?
              files_to_delete << dir + path
              yield(dir + path) if block_given?
            end
          end
        end
      end

      FileUtils.rm(files_to_delete.map(&:to_s))
    end

    def self.calculate(base_dir:, head_dir:, working_dir:)
      # @type var changed_paths: Array<Pathname>
      changed_paths = []
      # @type var unchanged_paths: Array<Pathname>
      unchanged_paths = []
      # @type var untracked_paths: Array<Pathname>
      untracked_paths = []

      Pathname.glob(working_dir + "**/*", File::FNM_DOTMATCH).each do |working_path|
        next unless working_path.file?

        relative_path = working_path.relative_path_from(working_dir)
        head_path = head_dir + relative_path
        base_path = base_dir + relative_path

        working_digest = Digest::SHA1.new.file(working_path.to_s)
        if head_path.file?
          head_digest = Digest::SHA1.new.file(head_path.to_s)

          if head_digest == working_digest
            if base_path.file?
              base_digest = Digest::SHA1.new.file(base_path.to_s)

              if head_digest == base_digest
                unchanged_paths << relative_path
              else
                changed_paths << relative_path
              end
            else
              changed_paths << relative_path
            end
          else
            untracked_paths << relative_path
          end
        else
          untracked_paths << relative_path
        end
      end

      new(changed_files: changed_paths.sort!.map {|path| ChangedFile.new(path: path) },
          unchanged_paths: unchanged_paths.sort!,
          untracked_paths: untracked_paths.sort!)
    end
  end
end
