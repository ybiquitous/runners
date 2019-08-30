require_relative "test_helper"
require "node_harness/cli"

class CLITest < Minitest::Test
  include TestHelper
  CLI = NodeHarness::CLI

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end

  def test_parsing_options
    cli = CLI.new(argv: %w(--analyzer=rubocop --base=base.tgz --head=https://example.com/head --base-key=basekey --head-key=headkey --ssh-key=id_rsa --working=/working/dir test-guid), stdout: stdout, stderr: stderr)

    # Given parameters
    assert_equal "test-guid", cli.guid
    assert_equal "base.tgz", cli.base
    assert_equal "https://example.com/head", cli.head
    assert_equal "basekey", cli.base_key
    assert_equal "headkey", cli.head_key
    assert_equal "id_rsa", cli.ssh_key
    assert_equal "/working/dir", cli.working_dir
    assert_equal 'rubocop', cli.analyzer
  end

  def test_validate_options!
    assert_raises RuntimeError do
      # head is missing
      CLI.new(argv: %w(--analyzer=rubocop --base=foo test-guid), stdout: stdout, stderr: stderr).validate_options!
    end

    assert_raises RuntimeError do
      # only base-key is given
      CLI.new(argv: %w(--analyzer=rubocop --base-key=topsecret --head=test test-guid), stdout: stdout, stderr: stderr).validate_options!
    end
  end

  def sider_yml
    {
      linter: {
        rubocop: {
          config: 'myrubocop.yml'
        }
      }
    }
  end

  class TestProcessor < NodeHarness::Processor
    def self.version
      "1.0.0"
    end

    def setup
      yield
    end

    def analyze(changes)
      trace_writer.command_line ["test", "command"]
      trace_writer.status Struct.new(:exitstatus).new(31)

      add_warning('hogehogewarn')

      NodeHarness::Results::Success.new(guid: guid, analyzer: NodeHarness::Analyzer.new(name: "test-analyzer", version: "3.14"))
    end
  end

  def test_run
    mktmpdir do |head_dir|
      head_dir.join('sider.yml').write(YAML.dump(sider_yml))
      cli = CLI.new(argv: ["--analyzer=rubocop", "--head=#{head_dir}", "test-guid"], stdout: stdout, stderr: stderr)
      cli.instance_variable_set(:@processor_class, TestProcessor)
      cli.run

      # It write JSON objects to stdout

      output = stdout.string
      reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
      objects = reader.each_object.to_a

      assert objects.find {|hash| hash[:trace] == 'command_line' && hash[:command_line] == ["test", "command"] }
      assert objects.find {|hash| hash[:trace] == 'status' && hash[:status] == 31 }
      assert objects.find {|hash| hash[:trace] == 'warning' && hash[:message] == 'hogehogewarn' }
      assert objects.find {|hash| hash[:"harness-version"] && hash[:result] }
      assert objects.find {|hash| hash[:warnings] == [{message: 'hogehogewarn', file: nil}]}
      assert objects.find {|hash| hash[:ci_config] == sider_yml}
    end
  end

  def test_run_when_sider_yml_is_broken
    mktmpdir do |head_dir|
      head_dir.join('sider.yml').write("1: 1:")
      cli = CLI.new(argv: ["--analyzer=rubocop", "--head=#{head_dir}", "test-guid"], stdout: stdout, stderr: stderr)
      cli.instance_variable_set(:@processor_class, TestProcessor)
      cli.run

      # It write JSON objects to stdout

      output = stdout.string
      reader = JSONSEQ::Reader.new(io: StringIO.new(output), decoder: -> (string) { JSON.parse(string, symbolize_names: true) })
      objects = reader.each_object.to_a

      assert objects.find {|hash| hash[:trace] == 'error' && hash[:message].match?(/Parse error occurred/) }
      assert objects.find {|hash| hash[:"harness-version"] && hash[:result] }
      assert objects.find {|hash| hash[:warnings] == []}
      assert objects.find {|hash| hash[:ci_config] == nil}
    end
  end

  def test_processor_class
    cli = CLI.new(argv: ["--analyzer=rubocop"], stdout: stdout, stderr: stderr)
    assert_equal NodeHarness::Runners::RuboCop::Processor, cli.processor_class

    cli = CLI.new(argv: ["--analyzer=scss_lint"], stdout: stdout, stderr: stderr)
    assert_equal NodeHarness::Runners::ScssLint::Processor, cli.processor_class

    cli = CLI.new(argv: ["--analyzer=foo"], stdout: stdout, stderr: stderr)
    error = assert_raises { cli.processor_class }
    assert_equal "Not found processor class with 'foo'", error.message
  end
end
