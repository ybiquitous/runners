module Runners
  module Ruby
    class InstallGemsFailure < StandardError; end

    def install_gems(default_specs, optionals: [], constraints:, &block)
      user_specs = GemInstaller::Spec.from_gems(ci_section["gems"] || [])

      LockfileLoader.new(root_dir: root_dir, shell: shell).ensure_lockfile do |lockfile|
        default_specs = default_specs(default_specs, constraints, lockfile)
        optionals = optional_specs(optionals, lockfile)
        user_specs = user_specs(user_specs, lockfile)
      end

      specs = GemInstaller::Spec.merge(default_specs, user_specs.size > 0 ? user_specs : optionals)

      Dir.mktmpdir do |dir|
        path = Pathname(dir)

        installer = GemInstaller.new(shell: shell,
                                     home: path,
                                     ci_config_path_name: ci_config_path_name,
                                     specs: specs,
                                     trace_writer: trace_writer,
                                     constraints: constraints)
        installer.install!(&block)
      end
    end

    def default_specs(specs, constraints, lockfile)
      specs.map do |spec|
        if lockfile.spec_exists?(spec.name)
          if lockfile.satisfied_by?(spec.name, constraints)
            spec.override_by_lockfile(lockfile)
          else
            add_warning <<~MESSAGE
              Sider tried to install `#{spec.name} #{lockfile.locked_version(spec.name)}` according to your `Gemfile.lock`, but it installs `#{spec.version.first}` instead.
              Because `#{lockfile.locked_version(spec.name)}` does not satisfy the Sider constraints #{constraints[spec.name]}.

              If you want to use a different version of `#{spec.name}`, update your `Gemfile.lock` to satisfy the constraint or specify the gem version in your `#{ci_config_path_name}`.
              See https://help.sider.review/getting-started/custom-configuration#gems-option
            MESSAGE
            spec
          end
        else
          spec
        end
      end
    end

    def optional_specs(specs, lockfile)
      specs.select { |spec| lockfile.spec_exists?(spec.name) }
           .map { |spec| spec.override_by_lockfile(lockfile) }
    end

    def user_specs(specs, lockfile)
      specs.map do |spec|
        if spec.version.empty?
          spec.override_by_lockfile(lockfile)
        else
          spec
        end
      end
    end

    def show_ruby_runtime_versions
      capture3! "ruby", "-v"
      capture3! "gem", "-v"
      capture3! "bundle", "-v"
    end
  end
end
