require_relative "test_helper"

class IssueTest < Minitest::Test
  include TestHelper

  Issues = Runners::Issues
  Location = Runners::Location

  def test_structured_issue
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issues::Structured.new(path: Pathname("app/models/person.rb"),
                                   location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
                                   id: "foo.bar",
                                   object: ["no such method??"],
                                   schema: s.object)

    assert issue.valid?

    assert_unifiable(issue.as_json, {
      path: "app/models/person.rb",
      location: :_,
      id: "foo.bar",
      object: ["no such method??"],
    })
  end

  def test_structured_issue_without_location
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issues::Structured.new(path: Pathname("app/models/person.rb"),
                                   location: nil,
                                   id: "foo.bar",
                                   object: ["no such method??"],
                                   schema: s.object)

    assert issue.valid?

    assert_unifiable(issue.as_json, {
      path: "app/models/person.rb",
      location: nil,
      id: "foo.bar",
      object: ["no such method??"],
    })
  end

  def test_structured_issue_with_invalid_object
    s = StrongJSON.new do
      let :object, array(string)
    end

    issue = Issues::Structured.new(
      path: Pathname("app/models/person.rb"),
      location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
      id: "foo.bar",
      object: [3],
      schema: s.object,
    )
    refute issue.valid?
    assert_equal ["Invalid `object`: [3]"], issue.errors
  end

  def test_structured_issue_with_object_schemes
    s = StrongJSON.new do
      let :strings, array(string)
      let :numbers, array(number)
    end

    Issues::Structured.new(path: Pathname("app/models/person.rb"),
                           location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
                           id: "foo.bar",
                           object: [3],
                           schema: [s.strings, s.numbers])
  end

  def test_structured_issue_without_object_schema
    Issues::Structured.new(path: Pathname("app/models/person.rb"),
                           location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
                           id: "foo.bar",
                           object: [3],
                           schema: nil)
  end

  def test_plaintext_issue
    issue = Issues::Text.new(path: Pathname("foo/bar"),
                             location: Location.new(start_line: 1, start_column: nil, end_line: 2, end_column: nil),
                             id: "missing.comment",
                             message: "Comment is missing??",
                             links: ["https://github.com/foo.bar"])

    assert issue.valid?

    assert_unifiable(issue.as_json, {
      path: "foo/bar",
      location: :_,
      id: "missing.comment",
      message: "Comment is missing??",
      links: ["https://github.com/foo.bar"]
    })
  end

  def test_validaion_errors_of_text_issue
    issue = Issues::Text.new(
      path: "foo/bar",
      location: Location.new(start_line: 1, start_column: 1, end_line: 2, end_column: nil),
      id: "",
      message: "",
      links: [1],
    )

    error = assert_raises(Issues::InvalidIssueError) { issue.ensure_validity }
    assert_equal <<~MSG.chomp, error.message
      Invalid path: "foo/bar"
      Invalid location: { start_line=1, start_column=1, end_line=2, end_column=nil }
      Empty `id`
      Empty `message`
      Not a string array: `links`
    MSG
  end

  def test_validaion_errors_of_structured_issue
    schema = StrongJSON.new do
      let :object, array(string)
    end
    issue = Issues::Structured.new(
      path: "foo/bar",
      location: Location.new(start_line: 1, start_column: 1, end_line: 2, end_column: nil),
      id: "",
      object: nil,
      schema: schema.object,
    )

    error = assert_raises(Issues::InvalidIssueError) { issue.ensure_validity }
    assert_equal <<~MSG.chomp, error.message
      Invalid path: "foo/bar"
      Invalid location: { start_line=1, start_column=1, end_line=2, end_column=nil }
      Empty `id`
      Empty `object`
    MSG
  end
end
