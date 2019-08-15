require_relative "test_helper"

class ProcessorTest < Minitest::Test
  include TestHelper

  def test_1
    processor head_dir: Pathname(__dir__) do |processor|
      assert_instance_of ::Processor, processor
    end
  end
end
