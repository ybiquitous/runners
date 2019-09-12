# Smoke test allows testing by input and output of the analysis.
# Following example, create "success" directory and put files, configurations, etc in this directory.
#

# Case: package.json が存在 && stylelintrc が存在
# Analysis: package.jsonから必要なパッケージをインストールし、解析する
NodeHarness::Testing::Smoke.add_test('success', {
  analyzer: {name: 'stylelint', version: '10.0.1'},
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {path: "test.sss",
     location: {start_line: 2},
     id: "block-closing-brace-newline-before",
     message:   "Expected newline before \"}\" of a multi-line block (block-closing-brace-newline-before)",
     links: []},
    {path: "test.sss",
     location: {start_line: 1},
     id: "block-opening-brace-space-before",
     message:   "Expected single space before \"{\" (block-opening-brace-space-before)",
     links: []},
    {path: "test.less",
     location: {start_line: 8},
     id: "declaration-block-trailing-semicolon",
     message:   "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
     links: []},
    {path: "test.sss",
     location: {start_line: 2},
     id: "declaration-block-trailing-semicolon",
     message:   "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
     links: []},
    {path: "test.scss",
     location: {start_line: 2},
     id: "indentation",
     message: "Expected indentation of 2 spaces (indentation)",
     links: []},
    {path: "test.less",
     location: {start_line: 11},
     id: "max-empty-lines",
     message: "Expected no more than 1 empty line (max-empty-lines)",
     links: []},
    {path: "test.less",
     location: {start_line: 12},
     id: "max-empty-lines",
     message: "Expected no more than 1 empty line (max-empty-lines)",
     links: []},
    {path: "test.css",
     location: {start_line: 2},
     id: "property-no-unknown",
     message:   "Unexpected unknown property \"someattr\" (property-no-unknown)",
     links: []},
    {path: "test.scss",
     location: {start_line: 6},
     id: "property-no-unknown",
     message:   "Unexpected unknown property \"font-color\" (property-no-unknown)",
     links: []},
    {path: "test.scss",
     location: {start_line: 3},
     id: "rule-empty-line-before",
     message: "Expected empty line before rule (rule-empty-line-before)",
     links: []},
    {path: "test.scss",
     location: {start_line: 5},
     id: "rule-empty-line-before",
     message: "Expected empty line before rule (rule-empty-line-before)",
     links: []},
    {path: "test.less",
     location: {start_line: 13},
     id: "selector-type-no-unknown",
     message:   "Unexpected unknown type selector \"hoge\" (selector-type-no-unknown)",
     links: []}
  ]
})

# Case: package.json が不在 && stylelintrc が不在
# Analysis: Global にインストールされた stylelint, stylelint-config-recommended を使って解析する
NodeHarness::Testing::Smoke.add_test('no_config', {
  analyzer: {name: 'stylelint', version: '10.1.0'},
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: "test.css",
      location: {start_line: 2},
      id: "color-no-invalid-hex",
      message: "Unexpected invalid hex color \"#100000000\" (color-no-invalid-hex)",
      links: []
    },
    {
      path: "test.css",
      location: {start_line: 1},
      id: "selector-type-no-unknown",
      message: "Unexpected unknown type selector \"foo\" (selector-type-no-unknown)",
      links: []
    }
  ]
})

# Case: package.json が不在 && stylelintrc が存在
# Analysis: stylelint-config-standard が存在しないので、解析エラーになる。
NodeHarness::Testing::Smoke.add_test('analyse-only-css', {
  analyzer: {name: 'stylelint', version: '10.1.0'},
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: /Error: Could not find "stylelint-config-standard"/
})

# Case: package.json が不在 && stylelintrc が不在
# Analysis: Global にインストールされた stylelint, stylelint-config-recommended を使って解析する
NodeHarness::Testing::Smoke.add_test('without-css', {
  analyzer: {name: 'stylelint', version: '10.1.0'},
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [],
})

NodeHarness::Testing::Smoke.add_test('without-css-v9', {
  analyzer: {name: 'stylelint', version: '9.10.1'},
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [],
})

# Case: package.json が存在 && stylelintrc が存在 && npm_install: true
#       package.json 中に stylelint, stylelint-config-standard が記載
# Analysis: npm でインストールした stylelint, stylelint-config-standard を使って解析する
NodeHarness::Testing::Smoke.add_test('with_options', {
  analyzer: { name: 'stylelint', version: '8.4.0' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Unnecessary curly bracket (CssSyntaxError)",
      links: [],
      id: "CssSyntaxError",
      path: "test.scss",
      location: { start_line: 1 } },
    { message: "Expected newline before \"}\" of a multi-line block (block-closing-brace-newline-before)",
      links: [],
      id: "block-closing-brace-newline-before",
      path: "test.sss",
      location: { start_line: 2 } },
    { message: "Expected single space before \"{\" (block-opening-brace-space-before)",
      links: [],
      id: "block-opening-brace-space-before",
      path: "test.sss",
      location: { start_line: 1 } },
    { message: "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
      links: [],
      id: "declaration-block-trailing-semicolon",
      path: "test.sss",
      location: { start_line: 2 } },
  ]
})

# Case: package.json が不在 && stylelintrc が不在
# Analysis: Global にインストールされた stylelint, stylelint-config-recommended を使って解析する
NodeHarness::Testing::Smoke.add_test('syntax-error', {
  analyzer: {name: 'stylelint', version: '10.1.0'},
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Unclosed block (CssSyntaxError)",
      links: [],
      id: "CssSyntaxError",
      path: "ng.css",
      location: { start_line: 1 } },
    { message: "Unexpected unknown property \"someattr\" (property-no-unknown)",
      links: [],
      id: "property-no-unknown",
      path: "ok.css",
      location: { start_line: 2 } }
  ],
})

# Case: package.json が不在 && stylelintrc が存在
# Analysis: Global にインストールされた stylelint, .stylelintrc の extends を元にインストールした stylelint-config-recommended を使って解析する
NodeHarness::Testing::Smoke.add_test('only_stylelintrc', {
  analyzer: { name: 'stylelint', version: '10.1.0' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Unexpected unknown property \"someattr\" (property-no-unknown)",
      links: [],
      id: "property-no-unknown",
      path: "test.css",
      location: { start_line: 2 } },
    { message: "Unexpected unknown property \"font-color\" (property-no-unknown)",
      links: [],
      id: "property-no-unknown",
      path: "test.scss",
      location: { start_line: 6 } },
    { message: "Unexpected unknown type selector \"hoge\" (selector-type-no-unknown)",
      links: [],
      id: "selector-type-no-unknown",
      path: "test.less",
      location: { start_line: 13 } }
  ]
})

# Case: package.json が不在 && stylelintrc が存在
#       stylelintrc は extends や plugins などを持たず、純粋にルールのみが記載
# Analysis: Global にインストールされた stylelint を使って解析する
NodeHarness::Testing::Smoke.add_test('only_stylelintrc_without_packages', {
  analyzer: { name: 'stylelint', version: '10.1.0' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Expected empty line before closing brace (block-closing-brace-empty-line-before)",
      links: [],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 16 } },
    { message: "Expected empty line before closing brace (block-closing-brace-empty-line-before)",
      links: [],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 17 } },
    { message: "Expected empty line before closing brace (block-closing-brace-empty-line-before)",
      links: [],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 20 } },
    { message: "Expected empty line before closing brace (block-closing-brace-empty-line-before)",
      links: [],
      id: "block-closing-brace-empty-line-before",
      path: "test.scss",
      location: { start_line: 21 } },
    { message: "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
      links: [],
      id: "declaration-block-trailing-semicolon",
      path: "test.scss",
      location: { start_line: 1 } },
    { message: "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
      links: [],
      id: "declaration-block-trailing-semicolon",
      path: "test.scss",
      location: { start_line: 19 } }
  ]
})

# Case: package.json が存在 && stylelintrc が存在 && npm_install: true
# Analysis: バージョンが古すぎて、インストールエラーとなる。
NodeHarness::Testing::Smoke.add_test('pinned_stylelint_version', {
  analyzer: nil,
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: /Your `stylelint` settings could not satisfy the required constraints/
})

# Case: package.json が存在 && stylelintrc が不在 && npm_install: true
# Analysis: npm でインストールした stylelint と Global にインストールされた stylelint-config-recommended を使って解析する
NodeHarness::Testing::Smoke.add_test('only_stylelint_in_package_json', {
  analyzer: { name: 'stylelint', version: '8.4.0' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Unexpected missing generic font family (font-family-no-missing-generic-family-keyword)",
      links: [],
      id: "font-family-no-missing-generic-family-keyword",
      path: "test.css",
      location: { start_line: 6 } },
    { message: "Unexpected unknown property \"someattr\" (property-no-unknown)",
      links: [],
      id: "property-no-unknown",
      path: "test.css",
      location: { start_line: 2 } },
    { message: "Unexpected unknown type selector \"hoge\" (selector-type-no-unknown)",
      links: [],
      id: "selector-type-no-unknown",
      path: "test.less",
      location: { start_line: 13 } }
  ]
})

# Case: package.json が存在 && stylelintrc が存在 && npm_install: true
# Analysis: peer dep が存在しないので、デフォルトにフォールバックする。
NodeHarness::Testing::Smoke.add_test('npm_install_without_stylelint', {
  analyzer: { name: "stylelint", version: "10.1.0" },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
      links: [],
      id: "declaration-block-trailing-semicolon",
      path: "test.less",
      location: { start_line: 8 } },
    { message: "Expected indentation of 2 spaces (indentation)",
      links: [],
      id: "indentation",
      path: "test.scss",
      location: { start_line: 2 } },
    { message: "Expected no more than 1 empty line (max-empty-lines)",
      links: [],
      id: "max-empty-lines",
      path: "test.less",
      location: { start_line: 11 } },
    { message: "Expected no more than 1 empty line (max-empty-lines)",
      links: [],
      id: "max-empty-lines",
      path: "test.less",
      location: { start_line: 12 } },
    { message: "Unexpected unknown property \"font-color\" (property-no-unknown)",
      links: [],
      id: "property-no-unknown",
      path: "test.scss",
      location: { start_line: 6 } },
    { message: "Expected empty line before rule (rule-empty-line-before)",
      links: [],
      id: "rule-empty-line-before",
      path: "test.scss",
      location: { start_line: 3 } },
    { message: "Expected empty line before rule (rule-empty-line-before)",
      links: [],
      id: "rule-empty-line-before",
      path: "test.scss",
      location: { start_line: 5 } },
    { message: "Unexpected unknown type selector \"hoge\" (selector-type-no-unknown)",
      links: [],
      id: "selector-type-no-unknown",
      path: "test.less",
      location: { start_line: 13 } },
  ],
}, {
  warnings: [
    { message: /The required dependency `stylelint` may not have been correctly installed/, file: "package.json" },
  ],
})

# Case: package.json が存在 && stylelintrc が存在 && npm_install: true
#       ただし、 package.json に不正な値が入っているため、npm install 自体は失敗する
# Analysis: インストールエラーになる。
NodeHarness::Testing::Smoke.add_test('failed_to_npm_install', {
  analyzer: nil,
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: /`npm install` failed./,
})

# Case: package.json が存在 && stylelintrc が存在 && npm_install オプションの記載なし
# Analysis: 設定に書かれてるパッケージがインストールされないので、エラーになる。
NodeHarness::Testing::Smoke.add_test('without_npm_install', {
  analyzer: { 'name': 'stylelint', version: '8.4.0' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: /Could not find "stylelint-processor-html"/
})

# Case: Failed to check sideci.yml schema because it has been broken.
NodeHarness::Testing::Smoke.add_test("broken_sideci_yml", {
  analyzer: nil,
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.stylelint.options.ignore-path`"
})

NodeHarness::Testing::Smoke.add_test("additional_options", {
  analyzer: { 'name': 'stylelint', version: '9.10.1' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "Expected newline before \"}\" of a multi-line block (block-closing-brace-newline-before)",
      links: [],
      id: "block-closing-brace-newline-before",
      path: "test.sss",
      location: { start_line: 2 } },
    { message: "Expected single space before \"{\" (block-opening-brace-space-before)",
      links: [],
      id: "block-opening-brace-space-before",
      path: "test.sss",
      location: { start_line: 1 } },
    { message: "Expected a trailing semicolon (declaration-block-trailing-semicolon)",
      links: [],
      id: "declaration-block-trailing-semicolon",
      path: "test.sss",
      location: { start_line: 2 } },
  ]
})

NodeHarness::Testing::Smoke.add_test("allow_empty_input_option_with_v10.0.0", {
  analyzer: { 'name': 'stylelint', version: '10.0.0' },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [],
})

NodeHarness::Testing::Smoke.add_test("mismatched_yarnlock_and_package_json", {
  analyzer: nil,
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "`yarn install` failed. Please confirm `yarn.lock` is consistent with `package.json`."
})

NodeHarness::Testing::Smoke.add_test("default_glob", {
  analyzer: { name: "stylelint", version: "10.1.0" },
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: "a.css",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: [],
    },
    {
      path: "a.less",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: [],
    },
    {
      path: "a.sass",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: [],
    },
    {
      path: "a.scss",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: [],
    },
    {
      path: "a.sss",
      id: "property-no-unknown",
      message: /Unexpected unknown property/,
      location: { start_line: 2 },
      links: [],
    },
  ],
})
