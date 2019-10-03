require_relative "test_helper"
require "runners/cli"

class CLITest < Minitest::Test
  include TestHelper
  CLI = Runners::CLI

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end

  def test_parsing_options
    cli = CLI.new(argv: %w(--analyzer=rubocop --base=base.tgz --head=https://example.com/head --base-key=basekey --head-key=headkey --ssh-key=id_rsa --working=/working/dir --output=s3://bucket/a/b/c test-guid), stdout: stdout, stderr: stderr)

    # Given parameters
    assert_equal "test-guid", cli.guid
    assert_equal "base.tgz", cli.base
    assert_equal "https://example.com/head", cli.head
    assert_equal "basekey", cli.base_key
    assert_equal "headkey", cli.head_key
    assert_equal "id_rsa", cli.ssh_key
    assert_equal "/working/dir", cli.working_dir
    assert_equal 'rubocop', cli.analyzer
    assert_equal ['s3://bucket/a/b/c'], cli.outputs
  end

  def test_parsing_options_without_commits
    h, hk, b, bk = %w[HEAD HEAD_KEY BASE BASE_KEY].map { |key| ENV[key] }
    [['HEAD', 'head url'], ['HEAD_KEY', 'h secret'], ['BASE', 'base url'], ['BASE_KEY', 'b secret']].each { |k, v| ENV[k] = v }

    cli = CLI.new(argv: %w(--analyzer=rubocop test-guid), stdout: stdout, stderr: stderr)

    # Given parameters
    assert_equal "test-guid", cli.guid
    assert_equal "base url", cli.base
    assert_equal "head url", cli.head
    assert_equal "b secret", cli.base_key
    assert_equal "h secret", cli.head_key
    assert_nil cli.ssh_key
    assert_nil cli.working_dir
    assert_equal 'rubocop', cli.analyzer
    assert_equal [], cli.outputs
  ensure
    [['HEAD', h], ['HEAD_KEY', hk], ['BASE', b], ['BASE_KEY', bk]].each { |k, v| ENV[k] = v }
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

  class TestProcessor < Runners::Processor
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

      Runners::Results::Success.new(guid: guid, analyzer: Runners::Analyzer.new(name: "test-analyzer", version: "3.14"))
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
      assert objects.find {|hash| hash[:warnings] == []}
      assert objects.find {|hash| hash[:ci_config] == nil}
    end
  end

  def test_run_when_s3_uri_is_passed
    mktmpdir do |head_dir|
      s3_mock = Object.new
      mock(s3_mock).write.with_any_args.at_least(1)
      mock(s3_mock).flush.at_least(1)
      mock(s3_mock).finalize!
      mock(Runners::IO::AwsS3).new("s3://dev-bucket/abc") { s3_mock }
      mock.proxy(Runners::IO).new(stdout, s3_mock)
      head_dir.join('sider.yml').write(YAML.dump(sider_yml))
      cli = CLI.new(argv: ["--analyzer=rubocop", "--head=#{head_dir}", "--output=stdout", "--output=s3://dev-bucket/abc", "test-guid"], stdout: stdout, stderr: stderr)
      cli.instance_variable_set(:@processor_class, TestProcessor)
      cli.run
    end
  end

  def test_processor_class
    cli = CLI.new(argv: ["--analyzer=rubocop"], stdout: stdout, stderr: stderr)
    assert_equal Runners::Processor::RuboCop, cli.processor_class

    cli = CLI.new(argv: ["--analyzer=scss_lint"], stdout: stdout, stderr: stderr)
    assert_equal Runners::Processor::ScssLint, cli.processor_class

    cli = CLI.new(argv: ["--analyzer=foo"], stdout: stdout, stderr: stderr)
    error = assert_raises { cli.processor_class }
    assert_equal "Not found processor class with 'foo'", error.message
  end
end
