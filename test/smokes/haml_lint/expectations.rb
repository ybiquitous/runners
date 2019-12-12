Smoke = Runners::Testing::Smoke

Smoke.add_test(
  'success',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: ["https://github.com/sds/haml-lint/blob/v0.34.1/lib/haml_lint/linter#classattributewithstaticvalue"],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: { severity: "warning" },
  }],
  analyzer: {name: 'haml_lint', version: '0.34.1'})

Smoke.add_test('with-sideci.yml', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: ["https://github.com/sds/haml-lint/blob/v0.34.1/lib/haml_lint/linter#classattributewithstaticvalue"],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: { severity: "warning" },
  }],
  analyzer: {name: 'haml_lint', version: '0.34.1'},
}, {
  warnings: [{ message: <<~MSG.strip, file: "sideci.yml" }],
    DEPRECATION WARNING!!!
    The `$.linter.haml_lint.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
    Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/ruby/haml-lint ).
  MSG
})

Smoke.add_test(
  'plain-rubocop',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`.",
    links: ["https://github.com/sds/haml-lint/blob/v0.34.1/lib/haml_lint/linter#rubocop"],
    id: "RuboCop",
    path: "test.haml",
    location: {start_line: 3 },
    object: { severity: "warning" },
  }],
  analyzer: {name: 'haml_lint', version: '0.34.1'})

Smoke.add_test(
  'with-inherit-gem',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`. (https://rubystyle.guide#underscore-unused-vars)",
    links: ["https://github.com/sds/haml-lint/blob/v0.34.0/lib/haml_lint/linter#rubocop"],
    id: "RuboCop",
    path: "test.haml",
    location: {start_line: 3 },
    object: { severity: "warning" },
  }],
  analyzer: {name: 'haml_lint', version: '0.34.0'})

Smoke.add_test(
  'rubocop-rspec',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: ["https://github.com/sds/haml-lint/blob/v0.34.1/lib/haml_lint/linter#classattributewithstaticvalue"],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: { severity: "warning" },
  }],
  analyzer: {name: 'haml_lint', version: '0.34.1'})

Smoke.add_test("with_exclude_files", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "3 consecutive Ruby scripts can be merged into a single `:ruby` filter",
      links: ["https://github.com/sds/haml-lint/blob/v0.34.1/lib/haml_lint/linter#consecutivesilentscripts"],
      id: "ConsecutiveSilentScripts",
      path: "hello.haml",
      location: { start_line: 2 },
      object: { severity: "warning" },
    },
    {
      message:  "Illegal nesting: content can't be both given on the same line as %span and nested within it.",
      links: [],
      id: "Syntax",
      path: "test.haml",
      location: { start_line: 3 },
      object: { severity: "error" },
    }
  ],
  analyzer: { name: 'haml_lint', version: '0.34.1' }
})

Smoke.add_test("broken_sideci_yml", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.haml_lint.config`",
  analyzer: nil
})

Smoke.add_test(
  'lowest-deps',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
             message: 'Avoid defining `class` in attributes hash for static class names',
             links: ["https://github.com/sds/haml-lint/blob/v0.26.0/lib/haml_lint/linter#classattributewithstaticvalue"],
             id: 'ClassAttributeWithStaticValue',
             path: 'test.haml',
             location: { start_line: 4 },
             object: { severity: "warning" },
           }],
  analyzer: {name: 'haml_lint', version: '0.26.0'})

Smoke.add_test(
  'incompatible_rubocop',
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: /Failed to install gems/,
  analyzer: nil)

# This test case, `incompatible_haml`, will be failed if updating HAML-Lint version,
# because HAML-Lint 4.1 beta support was dropped.
# https://github.com/sds/haml-lint/releases/tag/v0.31.0
Smoke.add_test(
  'incompatible_haml',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
             message: 'Avoid defining `class` in attributes hash for static class names',
             links: ["https://github.com/sds/haml-lint/blob/v0.28.0/lib/haml_lint/linter#classattributewithstaticvalue"],
             id: 'ClassAttributeWithStaticValue',
             path: 'test.haml',
             location: { start_line: 4 },
             object: { severity: "warning" },
           }],
  analyzer: {name: 'haml_lint', version: '0.28.0'}
)

# HAML-Lint v0.33.0 has supported HAML 5.1, therefore this test case checks brand-new HAML version.
# When HAML-Lint supports upper HAML version than 5.1, feel free to change pinned version such as `5.2`, `5.3`, ....
Smoke.add_test('pinned_haml_version', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: ["https://github.com/sds/haml-lint/blob/v0.32.0/lib/haml_lint/linter#classattributewithstaticvalue"],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: { severity: "warning" },
  }],
  analyzer: { name: 'haml_lint', version: '0.32.0' }
})

Smoke.add_test('missing_rubocop_required_gems', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: ["https://github.com/sds/haml-lint/blob/v0.34.1/lib/haml_lint/linter#classattributewithstaticvalue"],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 1 },
    object: { severity: "warning" },
  }],
  analyzer: { name: 'haml_lint', version: '0.34.1' },
}, {
  warnings: [{ message: 'cannot load such file -- rubocop-performance', file: nil }],
})
