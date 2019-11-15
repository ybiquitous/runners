module Runners
  class IO
    REQUIRED_METHODS_FOR_IOS = %i[write flush].freeze

    attr_reader :ios

    def initialize(*ios)
      @ios = ios.each do |io|
        raise ArgumentError unless REQUIRED_METHODS_FOR_IOS.all? { |method| io.respond_to?(method) }
      end
    end

    def write(*args)
      ios.each { |io| io.write(*args) }
    end

    def flush(*args)
      ios.each { |io| io.flush(*args) }
    end

    def flush!
      ios.each do |io|
        io.flush! if io.respond_to?(:flush!)
      end
    end
  end
end
