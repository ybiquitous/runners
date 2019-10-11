require_relative "test_helper"

class HarnessTest < Minitest::Test
  include TestHelper

  Harness = Runners::Harness
  Processor = Runners::Processor
  Results = Runners::Results
  Issue = Runners::Issue
  Location = Runners::Location
  Analyzer = Runners::Analyzer
  TraceWriter = Runners::TraceWriter
  Workspace = Runners::Workspace

  def trace_writer
    @trace_writer ||= TraceWriter.new(writer: [])
  end

  def with_workspace(base: nil, base_key: nil, head:, head_key: nil, &block)
    mktmpdir do |working_dir|
      Workspace.open(base: base, base_key: base_key, head: head, head_key: head_key, ssh_key: nil, working_dir: working_dir, trace_writer: trace_writer, &block)
    end
  end

  class TestProcessor < Processor
    def analyze(changes)
      Results::Success.new(guid: guid, analyzer: Analyzer.new(name: "Test", version: "0.1.3"))
    end
  end

  class BrokenProcessor < Processor
    def initialize(*args)
      raise StandardError
    end
  end

  def test_run
    with_workspace(head: Pathname(__dir__).join("data/foo.tgz").to_s) do |workspace|
      harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor, workspace: workspace, trace_writer: trace_writer)

      result = harness.run
      assert_instance_of Results::Success, result
    end
  end

  def test_run_when_using_broken_processor
    with_workspace(head: Pathname(__dir__).join("data/foo.tgz").to_s) do |workspace|
      harness = Harness.new(guid: SecureRandom.uuid, processor_class: BrokenProcessor, workspace: workspace, trace_writer: trace_writer)

      result = harness.run
      assert_instance_of Results::Error, result
    end
  end

  def test_run_filters_issues
    with_workspace(head: Pathname(__dir__).join("data/foo.tgz").to_s) do |workspace|
      processor = Class.new(Processor) do
        def analyze(changes)
          Results::Success.new(guid: guid, analyzer: Analyzer.new(name: "Test", version: "0.1.3")).tap do |result|
            result.add_issue Issue.new(
              path: Pathname("test/cli/test_test.rb"),
              location: Location.new(start_line: 0),
              id: "id1",
              message: "...",
            )
            result.add_issue Issue.new(
              path: Pathname("no_such_file"),
              location: Location.new(start_line: 0),
              id: "id2",
              message: "...",
            )
            result.add_issue Issue.new(
              path: Pathname("taggeing_test.rb"),
              location: Location.new(start_line: 0),
              id: "id3",
              message: "...",
            )
          end
        end
      end

      harness = Harness.new(guid: SecureRandom.uuid, processor_class: processor, workspace: workspace, trace_writer: trace_writer)

      result = harness.run
      assert_instance_of Results::Success, result
      assert_equal [Issue.new(
        path: Pathname("test/cli/test_test.rb"),
        location: Location.new(start_line: 0),
        id: "id1",
        message: "...",
      )], result.issues
    end
  end

  def test_run_when_root_dir_not_found
    with_workspace(head: Pathname(__dir__).join("data/foo.tgz").to_s) do |workspace|
      (workspace.working_dir / "sider.yml").write(YAML.dump({ "linter" => { TestProcessor.ci_config_section_name => { "root_dir" => "foo" } } }))

      harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor, workspace: workspace, trace_writer: trace_writer)
      assert_instance_of Results::Failure, harness.run
    end
  end

  def test_ensure_result_returns_succeee_result
    harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor, workspace: nil, trace_writer: trace_writer)

    result = harness.ensure_result do
      Results::Success.new(guid: harness.guid, analyzer: Analyzer.new(name: "foo", version: "3.2"))
    end

    assert_instance_of Results::Success, result
  end

  def test_ensure_result_returns_error_result_if_raised
    harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor, workspace: nil, trace_writer: trace_writer)

    result = harness.ensure_result do
      raise "Something wrong"
    end

    assert_instance_of Results::Error, result
    assert_instance_of RuntimeError, result.exception
  end

  def test_ensure_result_checks_validity_of_issues
    harness = Harness.new(guid: SecureRandom.uuid, processor_class: TestProcessor, workspace: nil, trace_writer: trace_writer)

    result = harness.ensure_result do
      Results::Success.new(guid: nil, analyzer: Analyzer.new(name: "foo", version: "1.0.3"))
    end

    assert_instance_of Results::Error, result
    assert_instance_of Harness::InvalidResult, result.exception
  end

  def test_setup_analyze
    processor = Class.new(Processor) do
      def setup
        (current_dir + "touch").write("#setup should be called before #analyze")
        yield
      end

      def analyze(changes)
        (current_dir + "touch").file? or raise
        Results::Success.new(guid: guid, analyzer: Analyzer.new(name: "Test", version: "0.1.3"))
      end
    end

    mktmpdir do |path|
      with_workspace(head: path.to_s) do |workspace|
        harness = Harness.new(guid: SecureRandom.uuid, processor_class: processor, workspace: workspace, trace_writer: trace_writer)
        result = harness.run

        assert_instance_of Results::Success, result
      end
    end
  end
end
