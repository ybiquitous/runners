$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'runners'

require 'minitest/autorun'
require "unification_assertion"
require "pp"
require "rr"

module TestHelper
  include UnificationAssertion

  def mktmpdir
    Dir.mktmpdir do |dir|
      yield Pathname(dir)
    end
  end

  def data(file)
    Pathname(__dir__).join("data", file)
  end

  def incorrect_yarn_data(file)
    Pathname(__dir__).join("incorrect_yarn_data", file)
  end

  def with_stubbed_env(name, value)
    backup = ENV[name]
    ENV[name] = value
    yield
  ensure
    ENV[name] = backup
  end

  def with_runners_options_env(hash)
    with_stubbed_env('RUNNERS_OPTIONS', JSON.dump(hash)) do
      yield
    end
  end
end
