module NodeHarness
  module Nodejs
    class DefaultDependencies
      attr_reader :main
      attr_reader :extras

      def initialize(main:, extras: [])
        @main = main
        @extras = extras
      end

      def all
        [main] + extras
      end
    end
  end
end
