module Runners
  module PHP
    def show_runtime_versions
      capture3! "php", "-version"
    end
  end
end
