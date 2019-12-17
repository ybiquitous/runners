module Runners
  module Python
    def show_runtime_versions
      # NOTE: `python --version` fails if `.python-version` file exists.
      capture3! "pyenv", "--version"
      capture3! "pyenv", "versions"
    end
  end
end
