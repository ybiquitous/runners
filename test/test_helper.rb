$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'node_harness'

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
end
