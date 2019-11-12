Smoke = Runners::Testing::Smoke

Smoke.add_test(
  'sample1',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: 'src/index.js',
      location: {
        start_line: 3
      },
      id: 'jshint.W067',
      message: 'Bad invocation.',
      links: [],
      object: nil,
    }
  ],
  analyzer: {
    name: 'JSHint',
    version: '2.10.2'
  }
)

Smoke.add_test(
  'es2015-code-without-config',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: 'index.js',
      location: {
        start_line: 1
      },
      id: 'jshint.W097',
      message: 'Use the function form of "use strict".',
      links: [],
      object: nil,
    },
    {
      path: 'index.js',
      location: {
        start_line: 9
      },
      id: 'jshint.W117',
      message: "'console' is not defined.",
      links: [],
      object: nil,
    },
    {
      path: 'index.js',
      location: {
        start_line: 16
      },
      id: 'jshint.W117',
      message: "'console' is not defined.",
      links: [],
      object: nil,
    }
  ],
  analyzer: {
    name: 'JSHint',
    version: '2.10.2'
  }
)

Smoke.add_test(
  'dir',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: 'src/app.js',
      location: {
        start_line: 3
      },
      id: 'jshint.W067',
      message: 'Bad invocation.',
      links: [],
      object: nil,
    }
  ],
  analyzer: {
    name: 'JSHint',
    version: '2.10.2'
  }
)

Smoke.add_test("broken_sideci_yml", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  analyzer: nil,
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.jshint.config`"
})

Smoke.add_test("with_options", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Bad invocation.",
      links: [],
      id: "jshint.W067",
      path: "src/index.js",
      location: { start_line: 3 },
      object: nil,
    }
  ],
  analyzer: { name: 'JSHint', version: '2.10.2' },
}, {
  warnings: [{ message: <<~MSG.strip, file: "sideci.yml" }],
    DEPRECATION WARNING!!!
    The `$.linter.jshint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
    Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/javascript/jshint ).
  MSG
})

Smoke.add_test("broken_package_json", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "JSHint", version: "2.10.2" },
}, {
  warnings: [
    { message: /`package.json` is broken: 767: unexpected token at/, file: "package.json" },
  ],
})

Smoke.add_test("invalid_output_xml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: 'The output XML is invalid: Illegal character "\\u0000" in raw string "Unexpected &apos;\\u0000&apos;."',
  analyzer: { name: "JSHint", version: "2.10.2" },
})
