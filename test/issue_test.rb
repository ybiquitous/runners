require_relative "test_helper"

class IssueTest < Minitest::Test
  include TestHelper

  Issue = Runners::Issue
  Location = Runners::Location

  def test_structured_issue
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issue.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      message: "test message",
      object: ["no such method??"],
      schema: s.object,
    )

    assert_equal({
      path: "app/models/person.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 1 },
      id: "foo.bar",
      message: "test message",
      links: [],
      object: ["no such method??"],
    }, issue.as_json)
  end

  def test_structured_issue_without_location
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issue.new(
      path: Pathname("app/models/person.rb"),
      location: nil,
      id: "foo.bar",
      message: "test message",
      object: ["no such method??"],
      schema: s.object,
    )

    assert_equal({
      path: "app/models/person.rb",
      location: nil,
      id: "foo.bar",
      message: "test message",
      links: [],
      object: ["no such method??"],
    }, issue.as_json)
  end

  def test_structured_issue_with_invalid_object
    s = StrongJSON.new do
      let :object, array(string)
    end

    error = assert_raises ArgumentError do
      Issue.new(
        path: Pathname("app/models/person.rb"),
        location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
        id: "foo.bar",
        message: "test message",
        object: [3],
        schema: s.object,
      )
    end
    assert_equal "#<StrongJSON::Type::TypeError: TypeError at $[0]: expected=string, value=3>", error.message
  end

  def test_structured_issue_with_object_schemas
    s = StrongJSON.new do
      let :strings, array(string)
      let :numbers, array(number)
    end

    Issue.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      message: "test message",
      object: [3],
      schema: [s.strings, s.numbers],
    )
  end

  def test_structured_issue_without_object_schema
    Issue.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      message: "test message",
      object: [3],
      schema: nil,
    )
  end

  def test_plaintext_issue
    issue = Issue.new(
      path: Pathname("foo/bar"),
      location: Location.new(start_line: 1, start_column: nil, end_line: 2, end_column: nil),
      id: "missing.comment",
      message: "Comment is missing??",
      links: ["https://github.com/foo.bar"],
    )

    assert_equal({
      path: "foo/bar",
      location: { start_line: 1, end_line: 2 },
      id: "missing.comment",
      message: "Comment is missing??",
      links: ["https://github.com/foo.bar"],
      object: nil,
    }, issue.as_json)
  end
end
