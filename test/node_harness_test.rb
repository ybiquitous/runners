require 'test_helper'

class NodeHarnessTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::NodeHarness::VERSION
  end
end
