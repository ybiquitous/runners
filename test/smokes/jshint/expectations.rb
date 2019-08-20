NodeHarness::Testing::Smoke.add_test(
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
      links: []
    }
  ],
  analyzer: {
    name: 'JSHint',
    version: '2.10.2'
  }
)

NodeHarness::Testing::Smoke.add_test(
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
      links: []
    },
    {
      path: 'index.js',
      location: {
        start_line: 9
      },
      id: 'jshint.W117',
      message: "'console' is not defined.",
      links: []
    },
    {
      path: 'index.js',
      location: {
        start_line: 16
      },
      id: 'jshint.W117',
      message: "'console' is not defined.",
      links: []
    }
  ],
  analyzer: {
    name: 'JSHint',
    version: '2.10.2'
  }
)

NodeHarness::Testing::Smoke.add_test(
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
      links: []
    }
  ],
  analyzer: {
    name: 'JSHint',
    version: '2.10.2'
  }
)

NodeHarness::Testing::Smoke.add_test("broken_sideci_yml", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  analyzer: nil,
  message: "Invalid configuration in sideci.yml: unexpected value at config: $.linter.jshint.options.config"
})

NodeHarness::Testing::Smoke.add_test("with_options", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Bad invocation.",
      links: [],
      id: "jshint.W067",
      path: "src/index.js",
      location: { start_line: 3 }
    }
  ],
  analyzer: { name: 'JSHint', version: '2.10.2' },
})
