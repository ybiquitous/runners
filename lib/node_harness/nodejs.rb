module NodeHarness
  module Nodejs
    class Error < StandardError; end
    class InvalidDefaultDependencies < Error; end
    class InvalidNodeVersion < Error; end
    class InvalidNpmVersion < Error; end
    class InvalidYarnVersion < Error; end

    class UserError < Error; end
    class DuplicateLockfiles < UserError; end
    class ConstraintsNotSatisfied < UserError; end
    class NpmInstallFailed < UserError; end
    class YarnInstallFailed < UserError; end

    INSTALL_OPTION_NONE = false
    INSTALL_OPTION_ALL = true
    INSTALL_OPTION_PRODUCTION = "production"
    INSTALL_OPTION_DEVELOPMENT = "development"

    # Return the just analyzer command name.
    def nodejs_analyzer_command
      raise NotImplementedError
    end

    # Return the locally installed analyzer command.
    def nodejs_analyzer_local_command
      "node_modules/.bin/#{nodejs_analyzer_command}"
    end

    # Return the analyzer command which will actually be ran.
    def nodejs_analyzer_bin
      nodejs_analyzer_locally_installed? ? nodejs_analyzer_local_command : nodejs_analyzer_command
    end

    def analyzer_version
      @analyzer_version ||= nodejs_analyzer_locally_installed? ? nodejs_analyzer_local_version : nodejs_analyzer_global_version
    end

    # Return the actual file path of `package.json`.
    def package_json_path
      current_dir / "package.json"
    end

    # Return the `Hash` content of `package.json`.
    def package_json
      @package_json ||= JSON.parse(package_json_path.read(encoding: Encoding::UTF_8), symbolize_names: true)
    end

    # Return the actual file path of `package-lock.json`.
    def package_lock_json_path
      current_dir / "package-lock.json"
    end

    # Return the actual file path of `yarn.lock`.
    def yarn_lock_path
      current_dir / "yarn.lock"
    end

    # Install Node.js dependencies by using given parameters.
    def install_nodejs_deps(defaults, constraints:, install_option:)
      install_option = INSTALL_OPTION_ALL if install_option.nil?

      check_nodejs_default_deps(defaults, constraints)

      return if install_option == INSTALL_OPTION_NONE

      if package_json_path.exist?
        check_duplicate_lockfiles

        if yarn_lock_path.exist?
          yarn_install(install_option)
        else
          npm_install(install_option)
        end

        check_installed_nodejs_deps(constraints, defaults.main)
      end
    end

    private

    def nodejs_analyzer_locally_installed?
      (current_dir / nodejs_analyzer_local_command).exist?
    end

    def nodejs_analyzer_global_version
      @nodejs_analyzer_global_version ||= extract_version!(nodejs_analyzer_command)
    end

    def nodejs_analyzer_local_version
      @nodejs_analyzer_local_version ||= extract_version!(nodejs_analyzer_local_command)
    end

    def check_nodejs_default_deps(defaults, constraints)
      defaults.all.each do |dependency|
        constraint = constraints[dependency.name]
        if constraint && constraint.unsatisfied_by?(dependency)
          raise InvalidDefaultDependencies, "The default dependency '#{dependency}' must satisfy the constraint '#{constraint}'"
        end
      end

      default = defaults.main
      actual_default_version = nodejs_analyzer_global_version
      unless default.version == actual_default_version
        raise InvalidDefaultDependencies, "The default dependency '#{default.name}' version must be '#{default.version}', but actually '#{actual_default_version}'"
      end
    end

    def check_duplicate_lockfiles
      if package_lock_json_path.exist? && yarn_lock_path.exist?
        message = <<~MSG.strip
          There are two duplicate lockfiles ('package-lock.json' and 'yarn.lock'). Please remove either for accurate analysis.
        MSG
        trace_writer.error message
        raise DuplicateLockfiles, message
      end
    end

    # @see https://docs.npmjs.com/cli/install
    # @see https://docs.npmjs.com/cli/ci
    def npm_install(option)
      cli_options = %w[
        --ignore-scripts
        --progress=false
        --engine-strict=false
      ]

      if package_lock_json_path.exist?
        subcommand = "ci"
      else
        subcommand = "install"
        cli_options << "--package-lock=false"
      end

      case option
      when INSTALL_OPTION_NONE
        return
      when INSTALL_OPTION_ALL
        # noop
      when INSTALL_OPTION_PRODUCTION
        cli_options << "--only=production"
      when INSTALL_OPTION_DEVELOPMENT
        cli_options << "--only=development"

        # NOTE: `npm ci --only=development` doesn't install anything. This seems to be a npm's bug.
        #
        # So this code fallback to `npm install` instead of `npm ci` to prevent analyses failing.
        if subcommand == "ci"
          subcommand = "install"
          cli_options << "--package-lock=false"
          add_warning <<~MSG.strip, file: "package.json"
            The 'npm ci --only=development' command doesn't install anything, so 'npm install --only=development' will be used instead.
            If you want to use 'npm ci', please change your install option from '#{INSTALL_OPTION_DEVELOPMENT}' to '#{INSTALL_OPTION_ALL}'.
            For details about the npm behavior, see https://npm.community/t/npm-ci-only-dev-does-not-install-anything/3068
          MSG
        end
      else
        raise "Unknown install option: #{option}"
      end

      begin
        capture3_with_retry! "npm", subcommand, *cli_options
      rescue Shell::ExecError
        message = <<~MSG.strip
          'npm #{subcommand}' failed. Please check the log for details.
          If you want to explicitly disable the installation, please set 'npm_install: #{INSTALL_OPTION_NONE}' on your '#{ci_config_path_name}'.
        MSG
        trace_writer.error message
        raise NpmInstallFailed, message
      end
    end

    # @see https://yarnpkg.com/en/docs/cli/install
    def yarn_install(option)
      cli_options = %w[
        --ignore-engines
        --ignore-scripts
        --no-progress
        --non-interactive
        --frozen-lockfile
      ]

      case option
      when INSTALL_OPTION_NONE
        return
      when INSTALL_OPTION_ALL
        # noop
      when INSTALL_OPTION_PRODUCTION
        cli_options << "--production"
      when INSTALL_OPTION_DEVELOPMENT
        add_warning <<~MSG.strip, file: "yarn.lock"
          Yarn doesn't have a same feature as 'npm install --only=development', so the option '#{INSTALL_OPTION_DEVELOPMENT}' will be ignored.
          See https://github.com/yarnpkg/yarn/issues/3254 for details.
        MSG
      else
        raise "Unknown install option: #{option}"
      end

      begin
        capture3_with_retry! "yarn", "install", *cli_options
      rescue Shell::ExecError
        message = "'yarn install' failed. Please confirm 'yarn.lock' is consistent with 'package.json'."
        trace_writer.error message
        raise YarnInstallFailed, message
      end
    end

    def check_installed_nodejs_deps(constraints, default_dependency)
      # NOTE: `npm ls` fails when any peer dependencies are missing.
      stdout, _, _ = capture3 "npm", "ls", "--depth=0", "--json"
      installed_deps = JSON.parse(stdout)["dependencies"]

      warn_about_fallback_to_default = -> {
        add_warning <<~MSG.strip, file: "package.json"
          No required dependencies for analysis were installed. Instead, the pre-installed '#{default_dependency}' will be used.
        MSG
      }

      unless installed_deps
        warn_about_fallback_to_default.call
        return
      end

      all_constraints_satisfied = true

      constraints.each do |name, constraint|
        installed_dep = installed_deps[name]

        unless installed_dep
          warn_about_fallback_to_default.call
          break
        end

        version = installed_dep["version"]
        unless version
          add_warning "The required dependency '#{name}' may not have been correctly installed. It may be a missing peer dependency.", file: "package.json"
          next
        end

        installed_dependency = Dependency.new(name: name, version: version)
        unless constraint.satisfied_by? installed_dependency
          trace_writer.error "The installed dependency '#{installed_dependency}' didn't satisfy the constraint '#{constraint}'."
          all_constraints_satisfied = false
          next
        end
      end

      unless all_constraints_satisfied
        message = <<~MSG.strip
          Your '#{nodejs_analyzer_command}' settings couldn't satisfy the required constraints. Please check your 'package.json' again.
          If you want to analyze via the Sider default settings, please configure your '#{ci_config_path_name}'. For details, see the documentation.
        MSG
        trace_writer.error message
        raise ConstraintsNotSatisfied, message
      end
    end
  end
end
