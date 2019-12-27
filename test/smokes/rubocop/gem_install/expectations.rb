Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "gem_install/install_from_sideci.yml-version_is_guessed_from_Gemfile.lock",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 5 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.50.0" }
  },
  warnings: [{ message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" }]
)

# It works correctly even if the specified gem not found in Gemfile.lock
# Previously, "Gem version for onkcop is not specified" error occurred in such cases
Smoke.add_test(
  "gem_install/install_from_sideci.yml-version_guessing_from_Gemfile.lock_is_failed",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Prefer single-quoted strings when you don't need string interpolation or special symbols.",
        links: %w[
          https://github.com/bbatsov/ruby-style-guide#consistent-string-literals
          https://github.com/rubocop-hq/rubocop/blob/v0.50.0/manual/cops_style.md#stylestringliterals
        ],
        id: "Style/StringLiterals",
        path: "Gemfile",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 1, start_column: 8, end_line: 1, end_column: 8 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.50.0" }
  },
  warnings: [{ message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_sideci.yml-version_is_specified_in_sideci.yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 5 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.50.0" }
  },
  warnings: [{ message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_sideci.yml-versions_are_specified_sideci.yml_or_guessed_from_Gemfile.lock",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 5 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.50.0" }
  },
  warnings: [{ message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_Gemfile.lock",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 5 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.50.0" }
  },
  warnings: [{ message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_Gemfile.lock-when_Gemfile.lock_is_generated_by_bundle_lock",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 5 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.50.0" }
  },
  warnings: [{ message: /The 0.50.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_sideci.yml_and_bundler_v1_Gemfile.lock",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 10 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.60.0" }
  },
  warnings: [{ message: /The 0.60.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_sideci.yml_when_installing_old_version_gems",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: <<~TEXT,
      Failed to install gems. Sider automatically installs gems according to `sideci.yml` and `Gemfile.lock`.
      You can select the version of gems you want to install via `sideci.yml`.
      See https://help.sider.review/getting-started/custom-configuration#gems-option
    TEXT
    analyzer: nil
  }
)

Smoke.add_test(
  "gem_install/install_from_sideci.yml_and_Gemfile.lock_when_gemspec_exists",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Use `expand_path('lib', __dir__)` instead of `expand_path('../lib', __FILE__)`.",
        links: %w[https://github.com/rubocop-hq/rubocop/blob/v0.60.0/manual/cops_style.md#styleexpandpatharguments],
        id: "Style/ExpandPathArguments",
        path: "test.gemspec",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 2, start_column: 12, end_line: 2, end_column: 22 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.60.0" }
  },
  warnings: [{ message: /The 0.60.0 and older versions are deprecated/, file: "Gemfile" }]
)

Smoke.add_test(
  "gem_install/install_from_git",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Line is too long. [91/80]",
        links: %w[
          https://github.com/rubocop-hq/ruby-style-guide#80-character-limits
          https://github.com/rubocop-hq/rubocop/blob/v0.63.1/manual/cops_metrics.md#metricslinelength
        ],
        id: "Metrics/LineLength",
        path: "Gemfile",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 81, end_line: 3, end_column: 91 }
      },
      {
        message: "Do not use `expect` in `before` hook",
        links: %w[http://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/ExpectInHook],
        id: "RSpec/ExpectInHook",
        path: "spec/a_spec.rb",
        object: { severity: "convention", corrected: false },
        git_blame_info: nil,
        location: { start_line: 3, start_column: 5, end_line: 3, end_column: 10 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.63.1" }
  }
)

Smoke.add_test(
  "gem_install/install_from_other_source",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: "Use the `&&` operator to compare multiple values.",
        links: %w[https://github.com/rubocop-hq/rubocop/blob/v0.60.0/manual/cops_lint.md#lintmultiplecompare],
        id: "Lint/MultipleCompare",
        path: "app.rb",
        object: { severity: "warning", corrected: false },
        git_blame_info: nil,
        location: { start_line: 2, start_column: 4, end_line: 2, end_column: 14 }
      }
    ],
    analyzer: { name: "RuboCop", version: "0.60.0" }
  },
  warnings: [{ message: /The 0.60.0 and older versions are deprecated/, file: "Gemfile" }]
)
