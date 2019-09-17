module Runners
  module Nodejs
    class Dependency
      attr_reader :name
      attr_reader :version

      def initialize(name:, version:)
        @name = name
        @version = version
      end

      def to_s
        "#{name}@#{version}"
      end
    end
  end
end
