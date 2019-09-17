module Runners
  module Ruby
    class GemInstaller
      class RubygemsSource
        attr_reader :source

        def initialize(source)
          @source = source
        end

        def ==(other)
          other.is_a?(self.class) && other.source == source
        end

        def to_s
          "source #{source.inspect}"
        end
      end
    end
  end
end
