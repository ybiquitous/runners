$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'node_harness'
require "node_harness/testing/support"

require 'minitest/autorun'
require "entrypoint"

module TestHelper
  include NodeHarness::Testing::Support
end
