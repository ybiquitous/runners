Smoke = Runners::Testing::Smoke

Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'swiftlint', version: '0.34.0'},
  issues: [
    {path: "test.swift",
     location: {start_line: 1},
     id: "identifier_name",
     message: "Function name should start with a lowercase character: 'Hello田()'",
     links: []}
  ]
})

Smoke.add_test("sideciyml", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'swiftlint', version: '0.34.0'},
  issues: [
    {path: "test.swift",
     location: {start_line: 1},
     id: "class_delegate_protocol",
     message:   "Delegate protocols should be class-only so they can be weakly referenced.",
    links: []},
    {path: "test.swift",
     location: {start_line: 6},
     id: "closure_parameter_position",
     message:   "Closure parameters should be on the same line as opening brace.",
     links: []},
    { message: "All declarations should specify Access Control Level keywords explicitly.",
      links: [],
      id: "explicit_acl",
      path: "test.swift",
      location: {start_line: 1}},
    {path: "test.swift",
     location: {start_line: 1},
     id: "explicit_top_level_acl",
     message: "Top-level declarations should specify Access Control Level keywords explicitly.",
     links: []},
    {:message=>
       "File name should match a type or extension declared in the file (if any).",
      :links=>[],
      :id=>"file_name",
      :path=>"test.swift",
      :location=>{:start_line=>1}},
    {:message=>
       "Multiline arguments should have their surrounding brackets in a new line.",
      :links=>[],
      :id=>"multiline_arguments_brackets",
      :path=>"test.swift",
      :location=>{:start_line=>8}},
    {message: "Trailing closure syntax should be used whenever possible.",
     links: [],
     id: "trailing_closure",
     path: "test.swift",
     location: {start_line: 5}},
    {path: "test.swift",
     location: {start_line: 2},
     id: "trailing_whitespace",
     message: "Lines should not have trailing whitespace.",
     links: []},
    {:message=>"Don't include vertical whitespace (empty line) before closing braces.",
     :links=>[],
     :id=>"vertical_whitespace_closing_braces",
     :path=>"test.swift",
     :location=>{:start_line=>2}},
    {:message=>"Don't include vertical whitespace (empty line) after opening braces.",
     :links=>[],
     :id=>"vertical_whitespace_opening_braces",
     :path=>"test.swift",
     :location=>{:start_line=>2}}
  ]
})

Smoke.add_test("ignore_warnings", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'swiftlint', version: '0.34.0'},
  issues: [
    {path: "test.swift",
     location: {start_line: 3},
     id: "force_cast",
     message:   "Force casts should be avoided.",
      links: []},
    ]
})

# TODO: This test sometimes fails for some reaason.
#       We skip this test for now.
# Smoke.add_test("no_swift_file", {
#   guid: "test-guid",
#   timestamp: :_,
#   type: "failure",
#   message:
#     "SwiftLint exited with unexpected status 1.\n" +
#     "STDOUT:\n" +
#     "\n" +
#     "STDERR:\n" +
#     "Linting Swift files at paths \n" +
#     "No lintable files found at paths: ''\n" +
#     "\n",
#   analyzer: {name: 'swiftlint', version: '0.34.0'},
# })

Smoke.add_test("no_config_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: /\ASwiftLint aborted\.\n(.+)\nCould not read configuration file at path (.+)/m,
  analyzer: {name: 'swiftlint', version: '0.34.0'},
})

Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.swiftlint.lenient`",
  analyzer: nil,
})

# TODO: This test sometimes fails for some reaason.
#       We skip this test for now.
# Smoke.add_test("wrong_swiftlint_version_set", {
#   guid: "test-guid",
#   timestamp: :_,
#   type: "failure",
#   message: <<~MESSAGE,
#     This analysis was failure since SwiftLint exited with status 2 and its stdout was empty.
#     STDERR:
#     Loading configuration from '.swiftlint.yml'
#     Currently running SwiftLint 0.34.0 but configuration specified version 0.0.0.
#
#   MESSAGE
#   analyzer: {name: 'swiftlint', version: '0.34.0'},
# })
