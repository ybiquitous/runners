module Runners
  module Python
    def show_runtime_versions
      capture3! "python", "--version"
      capture3! "pip", "--version"
      capture3! "pyenv", "--version"
    end
  end
end
