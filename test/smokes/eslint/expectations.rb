Smoke = Runners::Testing::Smoke

Smoke.add_test(
  'no_config',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {:message=> "Error - The update clause in this loop moves the variable in the wrong direction.",
     :links=>[],
     :id=>"for-direction",
     :path=>"index.js",
     :location=>{:start_line=>1},
     :object=>nil},
    {:message=> "Error - Empty block statement.",
     :links=>[],
     :id=>"no-empty",
     :path=>"index.js",
     :location=>{:start_line=>1},
     :object=>nil}],
  analyzer: {
    name: 'ESLint',
    version: '6.5.1'
  }
)

Smoke.add_test('sideci_valid_npm_install_option', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: "src/index.jsx",
      location: {
        start_line: 1
      },
      id: "filenames/no-index",
      message: "Error - 'index.js' files are not allowed.",
      links: [],
      object: nil,
    },
    {
      path: "src/App.jsx",
      location: {
        start_line: 3
      },
      id: "react/prefer-stateless-function",
      message: "Error - Component should be written as a pure function",
      links: [],
      object: nil,
    }
  ],
  analyzer: {
    name: 'ESLint',
    version: '3.19.0'
  }
}, {
  warnings: [{ message: /The version `3.19.0` is deprecated on Sider. `>= 4.19.1` is required/, file: "package.json" }],
})

# This test case's .eslintrc includes ESLint plugin, thus Sider fails because of the plugin unavailable.
Smoke.add_test(
  'only_eslintrc',
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: /ESLint couldn't find the plugin "eslint-plugin-filenames"/,
  analyzer: {
    name: 'ESLint',
    version: "6.5.1"
  }
)

Smoke.add_test('dir_option_is_array', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {:message=>
       "Error - 'index.js' files are not allowed.",
      :links=>[],
      :id=>"filenames/no-index",
      :path=>"dir1/index.jsx",
      :location=>{:start_line=>1},
      :object=>nil},
    {:message=>
      "Error - 'index.js' files are not allowed.",
     :links=>[],
     :id=>"filenames/no-index",
     :path=>"dir2/index.js",
     :location=>{:start_line=>1},
     :object=>nil},
    {:message=>
      "Error - JSX not allowed in files with extension '.js'",
     :links=>[],
     :id=>"react/jsx-filename-extension",
     :path=>"dir2/index.js",
     :location=>{:start_line=>4},
     :object=>nil},
    {:message=>
      "Error - Component should be written as a pure function",
     :links=>[],
     :id=>"react/prefer-stateless-function",
     :path=>"dir1/App.jsx",
     :location=>{:start_line=>3},
     :object=>nil}
  ],
  analyzer: {
    name: 'ESLint',
    version: '3.19.0'
  }
}, {
  warnings: [{ message: /The version `3.19.0` is deprecated on Sider. `>= 4.19.1` is required/, file: "package.json" }],
})

Smoke.add_test('dir_option_is_string', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {:message=> "Error - 'index.js' files are not allowed.",
     :links=>[],
     :id=>"filenames/no-index",
     :path=>"dir2/index.js",
     :location=>{:start_line=>1},
     :object=>nil},
    {:message=> "Error - JSX not allowed in files with extension '.js'",
     :links=>[],
     :id=>"react/jsx-filename-extension",
     :path=>"dir2/index.js",
     :location=>{:start_line=>4},
     :object=>nil}
  ],
  analyzer: {
    name: 'ESLint',
    version: '3.19.0'
  }
}, {
  warnings: [{ message: /The version `3.19.0` is deprecated on Sider. `>= 4.19.1` is required/, file: "package.json" }],
})

Smoke.add_test('pinned_eslint', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Error - Found identifier with same name as label.",
       links: [],
       id: "no-label-var",
       path: "src/index.js",
       location: { start_line: 3 },
       object: nil },
    { message: "Error - 'foo' is not defined.",
      links: [],
      id: "no-undef",
      path: "src/index.js",
      location: { start_line: 1 },
      object: nil },
    { message: "Error - 'x' is assigned a value but never used.",
      links: [],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 1 },
      object: nil },
    { message: "Error - 'bar' is defined but never used.",
      links: [],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 2 },
      object: nil }
  ],
  analyzer: { name: 'ESLint', version: '4.0.0'}
}, {
  warnings: [{ message: /The version `4.0.0` is deprecated on Sider. `>= 4.19.1` is required/, file: "package.json" }],
})

Smoke.add_test("no_files", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: <<~MESSAGE,
    stdout:


    stderr:

    Oops! Something went wrong! :(

    ESLint: 6.5.1.

    No files matching the pattern "." were found.
    Please check for typing mistakes in the pattern.


  MESSAGE
  analyzer: {
    name: 'ESLint',
    version: '6.5.1'
  }
})

Smoke.add_test("pinned_eslint5", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Error - Expected indentation of 8 space characters but found 6.",
      links: [],
      id: "react/jsx-indent",
      path: "src/App.jsx",
      location: { start_line: 6 },
      object: nil },
    { message: "Error - Missing JSX expression container around literal string",
      links: [],
      id: "react/jsx-no-literals",
      path: "src/App.jsx",
      location: { start_line: 6 },
      object: nil },
    { message: "Error - `Hello world.` must be placed on a new line",
      links: [],
      id: "react/jsx-one-expression-per-line",
      path: "src/App.jsx",
      location: { start_line: 6 },
      object: nil },
    { message: "Error - Component should be written as a pure function",
      links: [],
      id: "react/prefer-stateless-function",
      path: "src/App.jsx",
      location: { start_line: 3 },
      object: nil },
    { message: "Error - Component is not optimized. Please add a shouldComponentUpdate method.",
      links: [],
      id: "react/require-optimization",
      path: "src/App.jsx",
      location: { start_line: 3 },
      object: nil },
  ],
  analyzer: {
    name: 'ESLint',
    version: '5.1.0'
  }
})

Smoke.add_test("broken_config", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: :_, # Error: ESLint configuration in /tmp/d20180719-1-1qe6xeu/.eslintrc.yml is invalid: Unexpected top-level property "0".
  analyzer: {
    name: 'ESLint',
    version: :_
  }
})

Smoke.add_test("broken_sideci_yml", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.eslint.options.npm_install`",
  analyzer: nil
})

Smoke.add_test("quiet", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Error - Missing semicolon.",
      links: [],
      id: "semi",
      path: "test.js",
      location: { start_line: 1 },
      object: nil },
  ],
  analyzer: {
    name: 'ESLint',
    version: '6.5.1'
  }
})


Smoke.add_test("array_ignore_pattern", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Warning - This line has a length of 82. Maximum allowed is 10.",
      links: [],
      id: "max-len",
      path: "app.js",
      location: { start_line: 1 },
      object: nil },
    { message: "Error - Missing semicolon.",
      links: [],
      id: "semi",
      path: "app.js",
      location: { start_line: 1 },
      object: nil },
  ],
  analyzer: {
    name: 'ESLint',
    version: '6.5.1'
  }
})

Smoke.add_test("sider_config", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Error - Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "66d10b2b6c1cb7e5ef447158c3b5a87b99b1762c",
      path: "src/App.jsx",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Error - Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "66d10b2b6c1cb7e5ef447158c3b5a87b99b1762c",
      path: "src/application.jsx",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Error - 'foo' is not defined.",
      links: [],
      id: "no-undef",
      path: "src/index.js",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Error - 'x' is assigned a value but never used.",
      links: [],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Error - 'bar' is defined but never used.",
      links: [],
      id: "no-unused-vars",
      path: "src/index.js",
      location: { start_line: 2 },
      object: nil,
    }
  ],
  analyzer: {
    name: 'ESLint', version: "5.16.0"
  }
})

Smoke.add_test("no_ignore", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Error - Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "66d10b2b6c1cb7e5ef447158c3b5a87b99b1762c",
      path: "src/App.jsx",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Error - Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "66d10b2b6c1cb7e5ef447158c3b5a87b99b1762c",
      path: "src/index.jsx",
      location: { start_line: 1 },
      object: nil,
    }
  ],
  analyzer: {
    name: 'ESLint', version: "5.16.0"
  }
})

Smoke.add_test("additional_options", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Error - Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "66d10b2b6c1cb7e5ef447158c3b5a87b99b1762c",
      path: "src/App.jsx",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Error - Parsing error: The keyword 'import' is reserved",
      links: [],
      id: "66d10b2b6c1cb7e5ef447158c3b5a87b99b1762c",
      path: "src/application.jsx",
      location: { start_line: 1 },
      object: nil,
    }
  ],
  analyzer: {
    name: 'ESLint', version: "5.16.0"
  }
})

Smoke.add_test("prefer_npm_install_true_to_eslintrc", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: <<~MESSAGE.rstrip,
        Error - Parsing error: Unexpected token, expected ";"

          1 | function bar() {
        > 2 |   var x = foo:
            |              ^
          3 |   for (;;) {
          4 |     break x;
          5 |   }
      MESSAGE
      links: [],
      id: "40c21e5debb6189e0bd694e4bfabead7f84ec3b0",
      path: "index.js",
      location: { start_line: 2 },
      object: nil,
    }
  ],
  analyzer: {
    name: 'ESLint', version: '5.16.0'
  }
})

Smoke.add_test(
  'default_version_is_used',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [],
  analyzer: {
    name: 'ESLint',
    version: '6.5.1', # Default version
  }
)

Smoke.add_test("mismatched_package_version", {
  guid: 'test-guid',
  timestamp: :_,
  type: "failure",
  message: "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`.",
  analyzer: nil
})

Smoke.add_test("eslintrc_js", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "eqeqeq",
      message: "Error - Expected '===' and instead saw '=='.",
      links: [],
      path: "index.js",
      location: { start_line: 1 },
      object: nil,
    },
  ],
  analyzer: {
    name: "ESLint",
    version: "6.5.1",
  },
})
