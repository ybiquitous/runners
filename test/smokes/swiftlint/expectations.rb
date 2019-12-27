Smoke = Runners::Testing::Smoke

Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'swiftlint', version: '0.38.0'},
  issues: [
    {path: "test.swift",
     location: {start_line: 1},
     id: "identifier_name",
     message: "Function name should start with a lowercase character: 'Hello田()'",
     object: nil,
     git_blame_info: nil,
     links: []}
  ]
})

Smoke.add_test("sideciyml", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'swiftlint', version: '0.38.0'},
  issues: [
    {path: "test.swift",
     location: {start_line: 1},
     id: "class_delegate_protocol",
     message: "Delegate protocols should be class-only so they can be weakly referenced.",
     object: nil,
     git_blame_info: nil,
     links: []},
    {path: "test.swift",
     location: {start_line: 6},
     id: "closure_parameter_position",
     message: "Closure parameters should be on the same line as opening brace.",
     object: nil,
     git_blame_info: nil,
     links: []},
    { message: "All declarations should specify Access Control Level keywords explicitly.",
      links: [],
      id: "explicit_acl",
      path: "test.swift",
      object: nil,
      git_blame_info: nil,
      location: {start_line: 1}},
    {path: "test.swift",
     location: {start_line: 1},
     id: "explicit_top_level_acl",
     message: "Top-level declarations should specify Access Control Level keywords explicitly.",
     object: nil,
     git_blame_info: nil,
     links: []},
    {:message=>
       "File name should match a type or extension declared in the file (if any).",
      :links=>[],
      :id=>"file_name",
      :path=>"test.swift",
      :object=>nil,
      :git_blame_info=>nil,
      :location=>{:start_line=>1}},
    {:message=>
       "Multiline arguments should have their surrounding brackets in a new line.",
      :links=>[],
      :id=>"multiline_arguments_brackets",
      :path=>"test.swift",
      :object=>nil,
      :git_blame_info=>nil,
      :location=>{:start_line=>8}},
    {message: "Trailing closure syntax should be used whenever possible.",
     links: [],
     id: "trailing_closure",
     path: "test.swift",
     object: nil,
     git_blame_info: nil,
     location: {start_line: 5}},
    {path: "test.swift",
     location: {start_line: 2},
     id: "trailing_whitespace",
     message: "Lines should not have trailing whitespace.",
     object: nil,
     git_blame_info: nil,
     links: []},
    {:message=>"Don't include vertical whitespace (empty line) before closing braces.",
     :links=>[],
     :id=>"vertical_whitespace_closing_braces",
     :path=>"test.swift",
     :object=>nil,
     :git_blame_info=>nil,
     :location=>{:start_line=>2}},
    {:message=>"Don't include vertical whitespace (empty line) after opening braces.",
     :links=>[],
     :id=>"vertical_whitespace_opening_braces",
     :path=>"test.swift",
     :object=>nil,
     :git_blame_info=>nil,
     :location=>{:start_line=>2}}
  ]
})

Smoke.add_test("ignore_warnings", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'swiftlint', version: '0.38.0'},
  issues: [
    {path: "test.swift",
     location: {start_line: 3},
     id: "force_cast",
     message: "Force casts should be avoided.",
     object: nil,
     git_blame_info: nil,
     links: []},
    ]
})

Smoke.add_test("no_swift_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: {name: 'swiftlint', version: '0.38.0'},
}, {
  warnings: [
    { message: "No lintable files found.", file: nil },
  ]
})

Smoke.add_test("no_config_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: /\ASwiftLint aborted\.\n(.+)\nCould not read configuration file at path (.+)/m,
  analyzer: {name: 'swiftlint', version: '0.38.0'},
}, {
  warnings: [{ message: <<~MSG.strip, file: "sideci.yml" }],
    DEPRECATION WARNING!!!
    The `$.linter.swiftlint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
    Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/swift/swiftlint ).
  MSG
})

Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.swiftlint.lenient`",
  analyzer: nil,
})

Smoke.add_test("wrong_swiftlint_version_set", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  # TODO: The message sometimes can be "". It should be "Loading configuration from '.swiftlint.yml'".
  message: :_,
  analyzer: {name: 'swiftlint', version: '0.38.0'},
})
