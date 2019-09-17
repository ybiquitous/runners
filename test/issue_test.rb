require_relative "test_helper"

class IssueTest < Minitest::Test
  include TestHelper

  Issues = Runners::Issues
  Location = Runners::Location

  def test_identified_issue
    issue = Issues::Identified.new(path: Pathname("foo/bar.rb"),
                                   location: Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil),
                                   id: "foo.bar")

    assert issue.valid?

    assert_unifiable(issue.as_json, {
      path: "foo/bar.rb",
      location: :_,
      id: "foo.bar"
    })
  end

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

    assert_raises Issues::Structured::InvalidObject do
      Issues::Structured.new(path: Pathname("app/models/person.rb"),
                             location: Location.new(start_line: 1, start_column: 1, end_line: 1, end_column: 1),
                             id: "foo.bar",
                             object: [3],
                             schema: s.object)
    end
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
end
