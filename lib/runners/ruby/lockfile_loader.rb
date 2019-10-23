module Runners
  module Ruby
    class LockfileLoader
      class InvalidGemfileLock < InstallGemsFailure; end

      attr_reader :root_dir
      attr_reader :shell

      def initialize(root_dir:,  shell:)
        @root_dir = root_dir
        @shell = shell
      end

      def gemfile_path
        root_dir + "Gemfile"
      end

      def ensure_lockfile
        Dir.mktmpdir do |dir|
          original_lockfile_path = Pathname("#{gemfile_path.to_s}.lock")

          lockfile_path = case
                          when gemfile_path.file? && original_lockfile_path.file?
                            shell.trace_writer.message "Gemfile and Gemfile.lock detected"
                            original_lockfile_path
                          when gemfile_path.file?
                            shell.trace_writer.message "By using detected Gemfile, generating Gemfile.lock..."
                            generated_lockfile_path = Pathname(dir) + "Gemfile.lock"
                            begin
                              Bundler.with_clean_env do
                                shell.push_env_hash({ "BUNDLE_GEMFILE" => gemfile_path.to_s }) do
                                  shell.capture3!("bundle", "lock", "--lockfile", generated_lockfile_path.to_s)
                                  shell.trace_writer.message generated_lockfile_path.read
                                end
                              end
                              generated_lockfile_path
                            rescue Shell::ExecError
                              shell.trace_writer.error <<~MESSAGE
                                An error was found in your Gemfile but Sider continues the analysis by ignoring your dependencies.
                                If you want to make Sider aware of your dependencies, please fix the Gemfile according to the above error message, or commit your Gemfile.lock.
                              MESSAGE
                              nil
                            end
                          end

          begin
            yield Lockfile.new(lockfile_path)
          rescue Bundler::LockfileError
            raise InvalidGemfileLock.new(<<~MESSAGE)
              An error was found in the Gemfile.lock. Please fix the Gemfile.lock according to the above error message.
            MESSAGE
          end
        end
      end
    end
  end
end
