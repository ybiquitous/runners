module Runners
  module Ruby
    class GemInstaller
      class InstallationFailure < InstallGemsFailure; end

      DEFAULT_SOURCE = "https://rubygems.org"

      attr_reader :gem_home, :specs, :trace_writer, :shell, :constraints, :ci_config_path_name

      def initialize(shell:, home:, ci_config_path_name:, specs:, constraints:, trace_writer:)
        @gem_home = home
        @specs = specs
        @shell = shell
        @ci_config_path_name = ci_config_path_name
        @constraints = constraints
        @trace_writer = trace_writer
      end

      def gemfile_path
        gem_home + "Gemfile"
      end

      def lockfile_path
        gemfile_path.sub_ext(".lock")
      end

      def install!
        gemfile_path.write(gemfile_content.join("\n"))

        trace_writer.header "Installing gems..."

        Bundler.with_clean_env do
          shell.push_dir gem_home do
            shell.capture3!("bundle", "lock")
            shell.capture3!("bundle", "install", "--deployment", "--binstubs")
            shell.capture3!("bundle", "list")
          rescue Shell::ExecError
            raise InstallationFailure.new(<<~MESSAGE)
              Failed to install gems. Sider automatically installs gems according to `#{ci_config_path_name}` and `Gemfile.lock`.
              You can select the version of gems you want to install via `#{ci_config_path_name}`.
              See https://help.sider.review/getting-started/custom-configuration#gems-option
            MESSAGE
          end

          versions = LockfileParser.parse(lockfile_path.read).specs.map do |spec|
            [spec.name, spec.version.version]
          end.to_h

          shell.push_env_hash({ "BUNDLE_GEMFILE" => gemfile_path.to_s }) do
            yield versions
          end
        end
      end

      def gemfile_content
        trace_writer.header "Generating optimized Gemfile..."

        # @type var lines: Array<String>
        lines = ["source #{DEFAULT_SOURCE.inspect}"]

        specs.group_by(&:source).each do |source, specs|
          lines << "#{source} do"
          specs.each do |spec|
            versions = spec.version
            sider_constraints = self.constraints[spec.name] || []

            trace_writer.message "Installing `#{spec.name}` gem from #{source}..."
            trace_writer.message "  Specified version: #{versions.join(', ').presence || 'latest'}"
            trace_writer.message "  Sider constraints: #{sider_constraints.join(', ').presence || 'none'}"

            # @type var constraints: Array<String>
            constraints = if source.git?
                            # In deployment mode, the spec version constraints will cause an error like the following:
                            #
                            # The list of sources changed
                            #
                            # You have added to the Gemfile:
                            # * source: https://github.com/rubocop-hq/rubocop-rspec.git (at v1.32.0)
                            #
                            # You have deleted from the Gemfile:
                            # * source: https://github.com/rubocop-hq/rubocop-rspec.git (at v1.32.0@3626144)
                            sider_constraints
                          else
                            versions + sider_constraints
                          end
            lines << "  gem(#{spec.name.inspect}, #{constraints.map(&:inspect).join(", ")})"
          end
          lines << "end"
        end

        lines
      end
    end
  end
end
