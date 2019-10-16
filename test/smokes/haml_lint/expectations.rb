Smoke = Runners::Testing::Smoke

# frozen_string_literal: true

# Smoke test allows testing by input and output of the analysis.
# Following example, create "success" directory and put files, configurations, etc in this directory.
#
Smoke.add_test(
  'success',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: [],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: nil,
  }],
  analyzer: {name: 'haml_lint', version: '0.33.0'})

Smoke.add_test(
  'with-sideci.yml',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: [],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: nil,
  }],
  analyzer: {name: 'haml_lint', version: '0.33.0'})

Smoke.add_test(
  'plain-rubocop',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`.",
    links: [],
    id: "RuboCop",
    path: "test.haml",
    location: {start_line: 3 },
    object: nil,
  }],
  analyzer: {name: 'haml_lint', version: '0.33.0'})

Smoke.add_test(
  'with-inherit-gem',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: "Lint/UselessAssignment: Useless assignment to variable - `unused_variable`. (https://rubystyle.guide#underscore-unused-vars)",
    links: [],
    id: "RuboCop",
    path: "test.haml",
    location: {start_line: 3 },
    object: nil,
  }],
  analyzer: {name: 'haml_lint', version: '0.30.0'})

# rubocop-rspec will not be installed because `Gemfile.lock` does not exists.
# However, haml-lint does not stop to perform the analysis, and reports other offenses.
Smoke.add_test(
  'rubocop-rspec',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
    message: 'Avoid defining `class` in attributes hash for static class names',
    links: [],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: nil,
  }],
  analyzer: {name: 'haml_lint', version: '0.33.0'})

Smoke.add_test("with_exclude_files", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      message: "3 consecutive Ruby scripts can be merged into a single `:ruby` filter",
      links: [],
      id: "ConsecutiveSilentScripts",
      path: "hello.haml",
      location: { start_line: 2 },
      object: nil,
    },
    {
      message:  "Illegal nesting: content can't be both given on the same line as %span and nested within it.",
      links: [],
      id: "Syntax",
      path: "test.haml",
      location: { start_line: 3 },
      object: nil,
    }
  ],
  analyzer: { name: 'haml_lint', version: '0.33.0' }
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
             links: [],
             id: 'ClassAttributeWithStaticValue',
             path: 'test.haml',
             location: { start_line: 4 },
             object: nil,
           }],
  analyzer: {name: 'haml_lint', version: '0.26.0'})

Smoke.add_test(
  'incompatible_rubocop',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [{
             message: 'Avoid defining `class` in attributes hash for static class names',
             links: [],
             id: 'ClassAttributeWithStaticValue',
             path: 'test.haml',
             location: { start_line: 4 },
             object: nil,
           }],
  analyzer: {name: 'haml_lint', version: '0.33.0'})

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
             links: [],
             id: 'ClassAttributeWithStaticValue',
             path: 'test.haml',
             location: { start_line: 4 },
             object: nil,
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
    links: [],
    id: 'ClassAttributeWithStaticValue',
    path: 'test.haml',
    location: { start_line: 4 },
    object: nil,
  }],
  analyzer: { name: 'haml_lint', version: '0.32.0' }
})
