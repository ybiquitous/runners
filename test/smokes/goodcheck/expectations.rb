Smoke = Runners::Testing::Smoke

Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "com.goodcheck.hello",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 21, end_line: 1, end_column: 24 },
      message: "foo is not a good name...",
      links: [],
      object: {
        id: "com.goodcheck.hello",
        message: "foo is not a good name...",
        justifications: []
      }
    }
  ],
  analyzer: {
    name: "goodcheck",
    version: "2.4.0"
  }
})

Smoke.add_test("with_ci_config", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      object: {
        id: "com.sample",
        message: "Foo",
        justifications: []
      },
      message: "Foo",
      links: [],
      id: "com.sample",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 0, end_line: 1, end_column: 3 } }
  ],
  analyzer: {
    name: "goodcheck",
    version: "2.4.0"
  }
})

Smoke.add_test("no_config_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: {
    name: "goodcheck",
    version: "2.4.0"
  }
}, warnings: [
  { message: <<~MESSAGE, file: nil }
    Sider cannot find the required configuration file `goodcheck.yml`.
    Please set up Goodcheck by following the instructions, or you can disable it in the repository settings.

    - https://github.com/sider/goodcheck
    - https://help.sider.review/tools/others/goodcheck
  MESSAGE
])

Smoke.add_test("invalid_config_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "error",
  class: "JSON::ParserError",
  backtrace: :_,
  inspect: "#<JSON::ParserError: 767: unexpected token at ''>"
})

Smoke.add_test("with_invalid_ci_config", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.goodcheck.config`",
  analyzer: nil
})

Smoke.add_test('warning_config_file', {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: {
    name: "goodcheck",
    version: "2.4.0"
  }
}, warnings: [
  {message: <<~MESSAGE, file: 'goodcheck.yml'}
    Goodcheck configuration validation failed.
    Check the following output by `goodcheck test` command.

    Validating rule id uniqueness...
      OK!👍
    Testing rule com.example.github...
      Testing pattern...
        1st pass example matched.😱
        1st fail example didn't match.😱
  MESSAGE
])

Smoke.add_test("deprecated-options", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues:[],
  analyzer: {
    name: "goodcheck",
    version: "2.4.0"
  }
}, warnings: [
  { message: "👻 `case_insensitive` option is deprecated. Use `case_sensitive` option instead.", file: nil }
])

Smoke.add_test("lowest_deps", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "com.goodcheck.hello",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 21, end_line: 1, end_column: 24 },
      message: "foo is not a good name...",
      links: [],
      object: {
        id: "com.goodcheck.hello",
        message: "foo is not a good name...",
        justifications: []
      }
    }
  ],
  analyzer: {
    name: "goodcheck",
    version: "1.0.0"
  }
})

Smoke.add_test("detect_there_is_no_content", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      object: {
        id: "smoke",
        message: "Specify frozen_string_literal magic comment.",
        justifications: []
      },
      message: "Specify frozen_string_literal magic comment.",
      links: [],
      id: "smoke",
      path: "lib/duck.rb",
      location: nil
    }
  ],
  analyzer: {
    name: 'goodcheck',
    version: '2.4.0'
  }
})

Smoke.add_test("rules_without_pattern", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      object: {
        id: "com.goodcheck.without_pattern",
        message: <<~MESSAGE.chomp,
          Check the following documentation when editing this file.
            * https://example.com/path/to/note
        MESSAGE
        justifications: []
      },
      message: /Check the following documentation when editing this file/,
      links: [],
      id: "com.goodcheck.without_pattern",
      path: "app/checks/example.rb",
      location: nil
    }
  ],
  analyzer: {
    name: 'goodcheck',
    version: '2.4.0'
  }
})
