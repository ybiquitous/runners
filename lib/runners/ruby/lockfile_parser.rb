module Runners
  module Ruby
    module LockfileParser
      # HACK: This wrapper method aims to prevent the `Bundler::GemfileNotFound` error.
      #       Because Bundler assumes that the `Gemfile` file exists.
      #
      # @see https://github.com/bundler/bundler/blob/ebe0b853d8f2ac93f9c69768ee6af2c18fbc9d87/lib/bundler/shared_helpers.rb#L13-L17
      # @see https://github.com/bundler/bundler/blob/ebe0b853d8f2ac93f9c69768ee6af2c18fbc9d87/lib/bundler/shared_helpers.rb#L242-L246
      def parse(content)
        env_key = 'BUNDLE_GEMFILE'
        backup = ENV[env_key] if ENV[env_key]
        ENV[env_key] = 'Gemfile.dummy'
        ::Bundler::LockfileParser.new(content)
      ensure
        if backup
          ENV[env_key] = backup
        else
          ENV.delete env_key
        end
      end
      module_function :parse
    end
  end
end
