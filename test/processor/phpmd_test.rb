require "test_helper"

class Runners::Processor::PhpmdTest < Minitest::Test
  include TestHelper

  Phpmd = Runners::Processor::Phpmd

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def subject(workspace, yaml: nil)
    Phpmd.new(guid: SecureRandom.uuid, workspace: workspace, config: config(yaml), git_ssh_path: nil, trace_writer: trace_writer)
  end

  def test_target_files
    with_workspace do |workspace|
      assert_equal ["*.php"], subject(workspace).send(:target_files)
      assert_equal ["*.php"], subject(workspace, yaml: <<~YAML).send(:target_files)
        linter:
          phpmd:
            suffixes: php
      YAML
      assert_equal ["*.php", "*.phtml"], subject(workspace, yaml: <<~YAML).send(:target_files)
        linter:
          phpmd:
            suffixes: php,phtml
      YAML
      assert_equal ["*.a", "*.b"], subject(workspace, yaml: <<~YAML).send(:target_files)
        linter:
          phpmd:
            suffixes: a,b
      YAML
    end
  end
end
