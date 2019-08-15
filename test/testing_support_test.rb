require_relative "test_helper"
require "node_harness/testing/support"

class TestingSupportTest < Minitest::Test
  include NodeHarness::Testing::Support

  def with_processor(klass)
    NodeHarness.register_processor(klass)
    yield
  ensure
    NodeHarness.register_processor nil
  end

  class MyProcessor < NodeHarness::Processor

  end

  def test_processor_test
    path = Pathname(__dir__)

    with_processor MyProcessor do
      processor head_dir: path do |processor, changes|
        assert_instance_of MyProcessor, processor
        assert_instance_of NodeHarness::Changes, changes
      end
    end
  end
end
