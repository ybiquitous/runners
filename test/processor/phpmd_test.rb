require "test_helper"

class Runners::Processor::PhpmdTest < Minitest::Test
  Phpmd = Runners::Processor::Phpmd

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def subject
    Phpmd.new(guid: SecureRandom.uuid, working_dir: Pathname(__dir__), git_ssh_path: nil, trace_writer: trace_writer)
  end

  def test_target_files
    assert_equal ["*.php"], subject.send(:target_files, {})
    assert_equal ["*.php"], subject.send(:target_files, { suffixes: "php" })
    assert_equal ["*.php", "*.phtml"], subject.send(:target_files, { suffixes: "php,phtml" })
    assert_equal ["*.a", "*.b"], subject.send(:target_files, { suffixes: "a,b" })
  end
end
