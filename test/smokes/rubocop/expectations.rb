require_relative 'gem_install/expectations'

Smoke.add_test(
  'sandbox_rails',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {:message=>
       "Lint/LiteralAsCondition: Literal `true` appeared as a condition.",
      :links=>[],
      :id=>"Lint/LiteralAsCondition",
      :path=>"app/controllers/users_controller.rb",
      :object=>nil,
      :location=>
       {:start_line=>23, :start_column=>8, :end_line=>23, :end_column=>11}},
     {:message=>
       "Lint/ShadowingOuterLocalVariable: Shadowing outer local variable - `v`.",
      :links=>[],
      :id=>"Lint/ShadowingOuterLocalVariable",
      :path=>"app/controllers/users_controller.rb",
      :object=>nil,
      :location=>
       {:start_line=>27, :start_column=>30, :end_line=>27, :end_column=>30}},
     {:message=>
       "Lint/UselessAssignment: Useless assignment to variable - `v`.",
      :links=>["https://rubystyle.guide#underscore-unused-vars"],
      :id=>"Lint/UselessAssignment",
      :path=>"app/controllers/users_controller.rb",
      :object=>nil,
      :location=>
       {:start_line=>26, :start_column=>5, :end_line=>26, :end_column=>5}},
     {:message=>
       "Style/StringHashKeys: Prefer symbols instead of strings as hash keys.",
      :links=>["https://rubystyle.guide#symbols-as-keys"],
      :id=>"Style/StringHashKeys",
      :path=>"config/environments/development.rb",
      :object=>nil,
      :location=>
       {:start_line=>21, :start_column=>7, :end_line=>21, :end_column=>21}},
     {:message=>
       "Style/StringHashKeys: Prefer symbols instead of strings as hash keys.",
      :links=>["https://rubystyle.guide#symbols-as-keys"],
      :id=>"Style/StringHashKeys",
      :path=>"config/environments/test.rb",
      :object=>nil,
      :location=>
       {:start_line=>18, :start_column=>5, :end_line=>18, :end_column=>19}}
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.75.0'
    },
  }
)

Smoke.add_test(
  'without_display_cop_names',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      "message": "Style/Documentation: Missing top-level class documentation comment.",
      "links": [],
      "id": "Style/Documentation",
      "path": "app.rb",
      "location": {
        "start_line": 3,
        "start_column": 1,
        "end_line": 3,
        "end_column": 5
      },
      "object": nil,
    },
    {
      "message": "Style/EmptyMethod: Put empty method definitions on a single line.",
      "links": [
        "https://rubystyle.guide#no-single-line-methods"
      ],
      "id": "Style/EmptyMethod",
      "path": "app.rb",
      "location": {
        "start_line": 4,
        "start_column": 3,
        "end_line": 5,
        "end_column": 5
      },
      "object": nil,
    }
  ],
  analyzer: {
    name: 'RuboCop',
    version: '0.75.0'
  },
)

Smoke.add_test(
  'renamed-cop',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {:message=>
         "Layout/IndentationWidth: Use 2 (not 1) spaces for indentation.",
        :links=>
         ["https://github.com/bbatsov/ruby-style-guide#spaces-indentation"],
        :id=>"Layout/IndentationWidth",
        :path=>"test.rb",
        :object=>nil,
        :location=>
         {:start_line=>2, :start_column=>1, :end_line=>2, :end_column=>1}},
      {:message=>"Layout/Tab: Tab detected.",
       :links=>
         ["https://github.com/bbatsov/ruby-style-guide#spaces-indentation"],
       :id=>"Layout/Tab",
       :path=>"test.rb",
       :object=>nil,
       :location=>
        {:start_line=>2, :start_column=>1, :end_line=>2, :end_column=>1}}],
    analyzer: {
      name: 'RuboCop',
      version: '0.50.0'
    },
  },
  warnings: [
    { message: "The version `0.50.0` is deprecated on Sider. `>= 0.61.0` is required. Please consider upgrading to a new version.", file: "Gemfile" },
    { message: "Style/Tab has the wrong namespace - should be Layout", file: ".rubocop.yml" },
  ],
)

Smoke.add_test(
  'crash',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {:message=>
        "Style/FrozenStringLiteralComment: Missing magic comment `# frozen_string_literal: true`.",
       :links=>[],
       :id=>"Style/FrozenStringLiteralComment",
       :path=>"Gemfile",
       :object=>nil,
       :location=>
        {:start_line=>1, :start_column=>1, :end_line=>1, :end_column=>1}},
      {:message=>
        "Style/FrozenStringLiteralComment: Missing magic comment `# frozen_string_literal: true`.",
       :links=>[],
       :id=>"Style/FrozenStringLiteralComment",
       :path=>"test.rb",
       :object=>nil,
       :location=>
        {:start_line=>1, :start_column=>1, :end_line=>1, :end_column=>1}},
      {:message=>
        "Style/MultilineTernaryOperator: Avoid multi-line ternary operators, use `if` or `unless` instead.",
       :links=>
        ["https://github.com/bbatsov/ruby-style-guide#no-multiline-ternary"],
       :id=>"Style/MultilineTernaryOperator",
       :path=>"test.rb",
       :object=>nil,
       :location=>
        {:start_line=>2, :start_column=>1, :end_line=>2, :end_column=>1}}
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.50.0'
    },
  },
  warnings: [
    { message: "The version `0.50.0` is deprecated on Sider. `>= 0.61.0` is required. Please consider upgrading to a new version.", file: "Gemfile" },
    { message: "RuboCop crashes: An error occurred while Layout/MultilineOperationIndentation cop", file: "test.rb" },
  ],
)

Smoke.add_test(
  'inherit_from',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {:message=>
         "Metrics/LineLength: Line is too long. [218/200]",
       :links=>["https://github.com/bbatsov/ruby-style-guide#80-character-limits"],
       :id=>"Metrics/LineLength",
       :path=>"cat.rb",
       :object=>nil,
       :location=>
         {:start_line=>3, :start_column=>201, :end_line=>3, :end_column=>201}},
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.49.1',
    },
  },
  warnings: [
    { message: "The version `0.49.1` is deprecated on Sider. `>= 0.61.0` is required. Please consider upgrading to a new version.", file: "Gemfile" },
  ]
)

Smoke.add_test(
  'no_rubocop_yml',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {:message=>
         "Lint/MultipleCompare: Use the `&&` operator to compare multiple values.",
       :links=>[],
       :id=>"Lint/MultipleCompare",
       :path=>"test.rb",
       :object=>nil,
       :location=>
         {:start_line=>2, :start_column=>4, :end_line=>2, :end_column=>14}},
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.75.0',
    },
  }
)

Smoke.add_test(
  'exit2',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'failure',
    message: <<~TEXT,
      RuboCop exits with unexpected status 2.
      STDOUT:

      STDERR:
      Error: Cops cannot be both enabled by default and disabled by default

    TEXT
    analyzer: {
      name: 'RuboCop',
      version: '0.75.0',
    },
  }
)

Smoke.add_test('broken_sideci_yml', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  analyzer: nil,
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.rubocop.gems[0]`"
})

Smoke.add_test('with_safe_cops', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Lint/EmptyEnsure: Empty `ensure` block detected.",
      links: [],
      id: "Lint/EmptyEnsure",
      path: "drink.rb",
      location: { start_line: 12, start_column: 3, end_line: 12, end_column: 8 },
      object: nil,
    },
    {
      message:  "Lint/SafeNavigationChain: Do not chain ordinary method call after safe navigation operator.",
      links: [],
      id: "Lint/SafeNavigationChain",
      path: "drink.rb",
      location: { start_line: 18, start_column: 21, end_line: 18, end_column: 27 },
      object: nil,
    }
  ],
  analyzer: { name: 'RuboCop', version: '0.75.0' },
})

Smoke.add_test("using_option_with_incorrect_rubocop_version", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: <<~TEXT,
    RuboCop exits with unexpected status 2.
    STDOUT:

    STDERR:
    invalid option: --safe
    For usage information, use --help

  TEXT
  analyzer: { name: 'RuboCop', version: '0.59.2' },
}, warnings: [
  { message: "The version `0.59.2` is deprecated on Sider. `>= 0.61.0` is required. Please consider upgrading to a new version.", file: "Gemfile" }
])

Smoke.add_test('v0.71_rails', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Metrics/LineLength: Line is too long. [218/200]",
      links: ["https://github.com/rubocop-hq/ruby-style-guide#80-character-limits"],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: nil,
    },
  ],
  analyzer: { name: 'RuboCop', version: '0.71.0' },
}, warnings: [
  { message: <<~WARNING, file: :_},
    Rails cops will be removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
    https://github.com/rubocop-hq/rubocop/blob/master/manual/migrate_rails_cops.md
    https://help.sider.review/getting-started/custom-configuration#gems-option
  WARNING
])

Smoke.add_test('v0.72_rails', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Metrics/LineLength: Line is too long. [218/200]",
      links: ["https://rubystyle.guide#80-character-limits"],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: nil,
    },
  ],
  analyzer: { name: 'RuboCop', version: '0.72.0' },
})

Smoke.add_test('v0.72_rails_option', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Metrics/LineLength: Line is too long. [218/200]",
      links: ["https://rubystyle.guide#80-character-limits"],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: nil,
    },
  ],
  analyzer: { name: 'RuboCop', version: '0.72.0' },
}, warnings: [
  { message: <<~WARNING, file: "sideci.yml" },
      `rails` option is ignored because the option was removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
      See https://help.sider.review/getting-started/custom-configuration#gems-option
    WARNING
])
