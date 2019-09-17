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
                            shell.trace_writer.message "Gemfile & Gemfile.lock detected"
                            original_lockfile_path
                          when gemfile_path.file?
                            shell.trace_writer.message "Gemfile detected"
                            shell.trace_writer.message "Generating Gemfile.lock..."
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
                              shell.trace_writer.error "An error was found in Gemfile. But Sider will continue the analysis process by ignoring your dependencies."
                              shell.trace_writer.error "If you want to make us aware of your dependencies, Fix the Gemfile according to the above error messages, or commit your Gemfile.lock."
                              nil
                            end
                          end

          lockfile = begin
                       Lockfile.new(lockfile_path)
                     rescue Bundler::LockfileError
                       raise InvalidGemfileLock.new(<<~MESSAGE)
                         An error was found in `Gemfile.lock`. Fix the `Gemfile.lock` according to the above error messages.
                       MESSAGE
                     end

          yield lockfile
        end
      end
    end
  end
end
