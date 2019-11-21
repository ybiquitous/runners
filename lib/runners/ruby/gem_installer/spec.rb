module Runners
  module Ruby
    class GemInstaller
      class Spec
        class InvalidGemDefinition < SystemError; end

        attr_reader :name, :version, :source

        alias versions version

        def initialize(name:, version:, source: Source::Rubygems.new)
          @name = name
          @version = version
          @source = source
        end

        def ==(other)
          other.class == self.class && other.name == name && other.version == version && other.source == source
        end

        __skip__ = begin
          alias eql? ==
        end

        def override_by_lockfile(lockfile)
          locked_version = lockfile.locked_version(self)
          new_version = locked_version ? [locked_version] : version
          Spec.new(name: name, version: new_version, source: source)
        end

        def self.from_gems(gems_items)
          gems_items.map do |item|
            # @type var hash: gems_item
            hash = case (_ = item)
                   when Hash
                     _ = item
                   when String
                     { "name" => item, "version" => nil }
                   end

            name = hash["name"]
            version = hash["version"]

            # Schema validation is required in runner side
            raise InvalidGemDefinition.new("Unexpected gems_item: #{hash.inspect}") unless name

            spec_source =
              begin
                Source.create(hash)
              rescue => exn
                raise InvalidGemDefinition.new(exn.message)
              end

            self.new(
              name: name,
              version: version ? [version] : [],
              source: spec_source
            )
          end
        end

        def self.merge(default_gems, user_gems)
          specs = []

          default_gems_hash = default_gems.each.with_object({}) do |spec, hash|
            hash[spec.name] = spec
          end
          user_gems_hash = user_gems.each.with_object({}) do |spec, hash|
            hash[spec.name] = spec
          end

          default_gems_hash.each do |_, spec|
            if (user_spec = user_gems_hash[spec.name])
              specs << GemInstaller::Spec.new(
                name: spec.name,
                version: user_spec.version,
                source: user_spec.source
              )
            else
              specs << spec
            end
          end

          user_gems_hash.each do |_, spec|
            unless default_gems_hash.key?(spec.name)
              specs << spec
            end
          end

          specs
        end
      end
    end
  end
end
