require_relative "test_helper"

class ResultTest < Minitest::Test
  include TestHelper

  Results = NodeHarness::Results
  Issues = NodeHarness::Issues
  Location = NodeHarness::Location
  Analyzer = NodeHarness::Analyzer

  def test_success_result
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "Rubocop", version: "1.3.2pre"))
    result.add_issue Issues::Structured.new(
      path: Pathname("foo/bar/baz.rb"),
      location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
      id: "some_error_id",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )

    assert result.valid?

    assert NodeHarness::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601,
                       type: 'success',
                       issues: [
                         {
                           path: "foo/bar/baz.rb",
                           location: { start_line: 1 },
                           id: "some_error_id",
                           object: { args: [1,2,3] }
                         }
                       ],
                       analyzer: { name: "Rubocop", version: "1.3.2pre" }
                     })
  end

  def test_success_filter_issue
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "Rubocop", version: "1.3.2pre"))
    result.add_issue Issues::Structured.new(
      path: Pathname("foo/bar/baz.rb"),
      location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
      id: "some_error_id",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )
    result.add_issue Issues::Structured.new(
      path: Pathname("foo/bar/xxx.rb"),
      location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
      id: "some_error_id",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )


    result = result.filter_issue {|issue|
      issue.path == Pathname("foo/bar/xxx.rb")
    }

    assert result.valid?

    assert NodeHarness::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601,
                       type: 'success',
                       issues: [
                         {
                           path: "foo/bar/xxx.rb",
                           location: { start_line: 1 },
                           id: "some_error_id",
                           object: { args: [1,2,3] }
                         }
                       ],
                       analyzer: { name: "Rubocop", version: "1.3.2pre" }
                     })

  end

  def test_null_location_result
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "Goodcheck", version: "1.6.0"))
    result.add_issue Issues::Structured.new(
      path: Pathname("foo/bar/baz.rb"),
      location: nil,
      id: "some_error_id",
      object: {
        args: [1,2,3]
      },
      schema: nil
    )

    assert result.valid?

    assert NodeHarness::Schema::Result.success =~ result.as_json
    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601,
                       type: 'success',
                       issues: [
                         {
                           path: "foo/bar/baz.rb",
                           location: nil,
                           id: "some_error_id",
                           object: { args: [1,2,3] }
                         }
                       ],
                       analyzer: { name: "Goodcheck", version: "1.6.0" }
                     })
  end

  def test_success_result_raises_error_if_invalid_issue_added
    result = Results::Success.new(guid: SecureRandom.uuid, analyzer: Analyzer.new(name: "Querly", version: "0.1.3"))
    assert_raises Results::Success::InvalidIssue do
      result.add_issue Issues::Structured.new(
        path: Pathname("foo/bar/baz.rb"),
        location: Location.new(start_line: nil, start_column: nil, end_line: nil, end_column: nil),
        id: "some_error_id",
        object: {
          args: [1,2,3]
        },
        schema: nil
      )
    end
  end

  def test_failure_result
    result = Results::Failure.new(guid: SecureRandom.uuid, message: "Something wrong...")

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601,
                       type: "failure",
                       message: "Something wrong...",
                       analyzer: nil
                     })
  end

  def test_failure_result_with_analyzer
    result = Results::Failure.new(guid: SecureRandom.uuid, message: "Something wrong...", analyzer: Analyzer.new(name: "Foo", version: "bar"))

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601,
                       type: "failure",
                       message: "Something wrong...",
                       analyzer: { name: "Foo", version: "bar" }
                     })
  end

  def test_error_result
    result = Results::Error.new(guid: SecureRandom.uuid, exception: RuntimeError.new("some error!"))

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                       guid: result.guid,
                       timestamp: result.timestamp.utc.iso8601,
                       type: "error",
                       class: "RuntimeError",
                       backtrace: nil,
                       inspect: "#<RuntimeError: some error!>"
                     })
  end

  def test_missing_file_result
    result = Results::MissingFilesFailure.new(guid: SecureRandom.uuid, files: [Pathname("querly.yml")])

    assert result.valid?

    assert_unifiable(result.as_json,
                     {
                      guid: result.guid,
                      timestamp: result.timestamp.utc.iso8601,
                      type: "missing_files",
                      files: ["querly.yml"]
                     })
  end
end
