module NodeHarness
  module Ruby
    class LockfileLoader
      class Lockfile
        attr_reader :specs

        def initialize(lockfile_path)
          @specs = if lockfile_path
                    ::Bundler::LockfileParser.new(lockfile_path.read).specs
                   else
                     []
                   end
        end

        def spec_exists?(name)
          specs.any? {|spec| spec.name == name }
        end

        def locked_version(name)
          specs.find {|spec| spec.name == name }&.yield_self {|spec|
            spec.version.version
          }
        end

        def satisfied_by?(name, constraints)
          spec = specs.find { |s| s.name == name }
          raise "Spec not found: #{spec}, lockfile=#{specs.inspect}" unless spec
          Gem::Requirement.new(constraints[name]).satisfied_by?(spec.version)
        end
      end
    end
  end
end
