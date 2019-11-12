require_relative 'gem_install/expectations'

Smoke.add_test(
  'sandbox_rails',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'success',
    issues: [
      {:message=>
       "Literal `true` appeared as a condition.",
      :links=>["https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_lint.md#lintliteralascondition"],
      :id=>"Lint/LiteralAsCondition",
      :path=>"app/controllers/users_controller.rb",
      :object=>{:severity=>"warning", :corrected=>false},
      :location=>
       {:start_line=>23, :start_column=>8, :end_line=>23, :end_column=>11}},
     {:message=>
       "Shadowing outer local variable - `v`.",
      :links=>["https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_lint.md#lintshadowingouterlocalvariable"],
      :id=>"Lint/ShadowingOuterLocalVariable",
      :path=>"app/controllers/users_controller.rb",
      :object=>{:severity=>"warning", :corrected=>false},
      :location=>
       {:start_line=>27, :start_column=>30, :end_line=>27, :end_column=>30}},
     {:message=>
       "Useless assignment to variable - `v`.",
      :links=>["https://rubystyle.guide#underscore-unused-vars", "https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_lint.md#lintuselessassignment"],
      :id=>"Lint/UselessAssignment",
      :path=>"app/controllers/users_controller.rb",
      :object=>{:severity=>"warning", :corrected=>false},
      :location=>
       {:start_line=>26, :start_column=>5, :end_line=>26, :end_column=>5}},
     {:message=>
       "Prefer symbols instead of strings as hash keys.",
      :links=>["https://rubystyle.guide#symbols-as-keys", "https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_style.md#stylestringhashkeys"],
      :id=>"Style/StringHashKeys",
      :path=>"config/environments/development.rb",
      :object=>{:severity=>"convention", :corrected=>false},
      :location=>
       {:start_line=>21, :start_column=>7, :end_line=>21, :end_column=>21}},
     {:message=>
       "Prefer symbols instead of strings as hash keys.",
      :links=>["https://rubystyle.guide#symbols-as-keys", "https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_style.md#stylestringhashkeys"],
      :id=>"Style/StringHashKeys",
      :path=>"config/environments/test.rb",
      :object=>{:severity=>"convention", :corrected=>false},
      :location=>
       {:start_line=>18, :start_column=>5, :end_line=>18, :end_column=>19}}
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.76.0'
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
      "message": "Missing top-level class documentation comment.",
      "links": ["https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_style.md#styledocumentation"],
      "id": "Style/Documentation",
      "path": "app.rb",
      "location": {
        "start_line": 3,
        "start_column": 1,
        "end_line": 3,
        "end_column": 5
      },
      "object": {
        "severity": "convention",
        "corrected": false,
      },
    },
    {
      "message": "Put empty method definitions on a single line.",
      "links": [
        "https://rubystyle.guide#no-single-line-methods",
        "https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_style.md#styleemptymethod",
      ],
      "id": "Style/EmptyMethod",
      "path": "app.rb",
      "location": {
        "start_line": 4,
        "start_column": 3,
        "end_line": 5,
        "end_column": 5
      },
      "object": {
        "severity": "convention",
        "corrected": false,
      },
    }
  ],
  analyzer: {
    name: 'RuboCop',
    version: '0.76.0'
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
         "Use 2 (not 1) spaces for indentation.",
        :links=>
         ["https://github.com/bbatsov/ruby-style-guide#spaces-indentation", "https://github.com/rubocop-hq/rubocop/blob/v0.50.0/manual/cops_layout.md#layoutindentationwidth"],
        :id=>"Layout/IndentationWidth",
        :path=>"test.rb",
        :object=>{:severity=>"convention", :corrected=>false},
        :location=>
         {:start_line=>2, :start_column=>1, :end_line=>2, :end_column=>1}},
      {:message=>"Tab detected.",
       :links=>
         ["https://github.com/bbatsov/ruby-style-guide#spaces-indentation", "https://github.com/rubocop-hq/rubocop/blob/v0.50.0/manual/cops_layout.md#layouttab"],
       :id=>"Layout/Tab",
       :path=>"test.rb",
       :object=>{:severity=>"convention", :corrected=>false},
       :location=>
        {:start_line=>2, :start_column=>1, :end_line=>2, :end_column=>1}}],
    analyzer: {
      name: 'RuboCop',
      version: '0.50.0'
    },
  },
  warnings: [
    { message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" },
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
        "Missing magic comment `# frozen_string_literal: true`.",
       :links=>["https://github.com/rubocop-hq/rubocop/blob/v0.50.0/manual/cops_style.md#stylefrozenstringliteralcomment"],
       :id=>"Style/FrozenStringLiteralComment",
       :path=>"Gemfile",
       :object=>{:severity=>"convention", :corrected=>false},
       :location=>
        {:start_line=>1, :start_column=>1, :end_line=>1, :end_column=>1}},
      {:message=>
        "Missing magic comment `# frozen_string_literal: true`.",
       :links=>["https://github.com/rubocop-hq/rubocop/blob/v0.50.0/manual/cops_style.md#stylefrozenstringliteralcomment"],
       :id=>"Style/FrozenStringLiteralComment",
       :path=>"test.rb",
       :object=>{:severity=>"convention", :corrected=>false},
       :location=>
        {:start_line=>1, :start_column=>1, :end_line=>1, :end_column=>1}},
      {:message=>
        "Avoid multi-line ternary operators, use `if` or `unless` instead.",
       :links=>
        ["https://github.com/bbatsov/ruby-style-guide#no-multiline-ternary", "https://github.com/rubocop-hq/rubocop/blob/v0.50.0/manual/cops_style.md#stylemultilineternaryoperator"],
       :id=>"Style/MultilineTernaryOperator",
       :path=>"test.rb",
       :object=>{:severity=>"convention", :corrected=>false},
       :location=>
        {:start_line=>2, :start_column=>1, :end_line=>2, :end_column=>1}}
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.50.0'
    },
  },
  warnings: [
    { message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" },
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
         "Line is too long. [218/200]",
       :links=>["https://github.com/bbatsov/ruby-style-guide#80-character-limits", "https://github.com/rubocop-hq/rubocop/blob/v0.49.1/manual/cops_metrics.md#metricslinelength"],
       :id=>"Metrics/LineLength",
       :path=>"cat.rb",
       :object=>{:severity=>"convention", :corrected=>false},
       :location=>
         {:start_line=>3, :start_column=>201, :end_line=>3, :end_column=>201}},
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.49.1',
    },
  },
  warnings: [
    { message: /The 0.49.1 and older versions are deprecated/, file: "Gemfile" },
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
         "Use the `&&` operator to compare multiple values.",
       :links=>["https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_lint.md#lintmultiplecompare"],
       :id=>"Lint/MultipleCompare",
       :path=>"test.rb",
       :object=>{:severity=>"warning", :corrected=>false},
       :location=>
         {:start_line=>2, :start_column=>4, :end_line=>2, :end_column=>14}},
    ],
    analyzer: {
      name: 'RuboCop',
      version: '0.76.0',
    },
  }
)

Smoke.add_test(
  'exit2',
  {
    guid: 'test-guid',
    timestamp: :_,
    type: 'failure',
    message: 'Error: Cops cannot be both enabled by default and disabled by default',
    analyzer: {
      name: 'RuboCop',
      version: '0.76.0',
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
      message: "Empty `ensure` block detected.",
      links: ["https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_lint.md#lintemptyensure"],
      id: "Lint/EmptyEnsure",
      path: "drink.rb",
      location: { start_line: 12, start_column: 3, end_line: 12, end_column: 8 },
      object: { severity: "warning", corrected: false },
    },
    {
      message:  "Do not chain ordinary method call after safe navigation operator.",
      links: ["https://github.com/rubocop-hq/rubocop/blob/v0.76.0/manual/cops_lint.md#lintsafenavigationchain"],
      id: "Lint/SafeNavigationChain",
      path: "drink.rb",
      location: { start_line: 18, start_column: 21, end_line: 18, end_column: 27 },
      object: { severity: "warning", corrected: false },
    }
  ],
  analyzer: { name: 'RuboCop', version: '0.76.0' },
})

Smoke.add_test("using_option_with_incorrect_rubocop_version", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "invalid option: --safe\nFor usage information, use --help",
  analyzer: { name: 'RuboCop', version: '0.59.2' },
}, warnings: [
  { message: /The 0.59.2 and older versions are deprecated/, file: "Gemfile" }
])

Smoke.add_test('v0.71_rails', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "Line is too long. [218/200]",
      links: ["https://github.com/rubocop-hq/ruby-style-guide#80-character-limits", "https://github.com/rubocop-hq/rubocop/blob/v0.71.0/manual/cops_metrics.md#metricslinelength"],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
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
      message: "Line is too long. [218/200]",
      links: ["https://rubystyle.guide#80-character-limits", "https://github.com/rubocop-hq/rubocop/blob/v0.72.0/manual/cops_metrics.md#metricslinelength"],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
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
      message: "Line is too long. [218/200]",
      links: ["https://rubystyle.guide#80-character-limits", "https://github.com/rubocop-hq/rubocop/blob/v0.72.0/manual/cops_metrics.md#metricslinelength"],
      id: "Metrics/LineLength",
      path: "cat.rb",
      location: { start_line: 3, start_column: 201, end_line: 3, end_column: 218 },
      object: { severity: "convention", corrected: false },
    },
  ],
  analyzer: { name: 'RuboCop', version: '0.72.0' },
}, warnings: [
  { message: <<~WARNING, file: "sideci.yml" },
      `rails` option is ignored because the option was removed from RuboCop 0.72. Use the `rubocop-rails` gem instead.
      See https://help.sider.review/getting-started/custom-configuration#gems-option
    WARNING
])

Smoke.add_test("rails_and_performance", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      message: "Use `caller(2..2).first` instead of `caller[1]`.",
      links: ["https://github.com/rubocop-hq/rubocop-performance/blob/v1.5.0/manual/cops_performance.md#performancecaller"],
      id: "Performance/Caller",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 9 },
      object: { severity: "convention", corrected: false },
    },
    {
      message: "Do not use `exit` in Rails applications.",
      links: ["https://github.com/rubocop-hq/rubocop-rails/blob/v2.3.2/manual/cops_rails.md#railsexit"],
      id: "Rails/Exit",
      path: "app/foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      object: { severity: "convention", corrected: false },
    },
    {
      message: "Please use `Rails.root.join('path', 'to')` instead.",
      links: ["https://github.com/rubocop-hq/rubocop-rails/blob/v2.3.2/manual/cops_rails.md#railsfilepath"],
      id: "Rails/FilePath",
      path: "app/foo.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 33 },
      object: { severity: "convention", corrected: false },
    },
  ],
  analyzer: { name: "RuboCop", version: "0.76.0" },
})

Smoke.add_test("rails_and_performance_old", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      message: "Use `caller(2..2).first` instead of `caller[1]`.",
      links: ["https://github.com/rubocop-hq/rubocop/blob/v0.67.0/manual/cops_performance.md#performancecaller"],
      id: "Performance/Caller",
      path: "app/foo.rb",
      location: { start_line: 1, start_column: 1, end_line: 1, end_column: 9 },
      object: { severity: "convention", corrected: false },
    },
    {
      message: "Do not use `exit` in Rails applications.",
      links: ["https://github.com/rubocop-hq/rubocop/blob/v0.67.0/manual/cops_rails.md#railsexit"],
      id: "Rails/Exit",
      path: "app/foo.rb",
      location: { start_line: 3, start_column: 1, end_line: 3, end_column: 4 },
      object: { severity: "convention", corrected: false },
    },
    {
      message: "Please use `Rails.root.join('path', 'to')` instead.",
      links: ["https://github.com/rubocop-hq/rubocop/blob/v0.67.0/manual/cops_rails.md#railsfilepath"],
      id: "Rails/FilePath",
      path: "app/foo.rb",
      location: { start_line: 2, start_column: 1, end_line: 2, end_column: 33 },
      object: { severity: "convention", corrected: false },
    },
  ],
  analyzer: { name: "RuboCop", version: "0.67.0" },
})
