s = Runners::Testing::Smoke

s.add_test(
  "broken_sideci_yml",
  type: "failure",
  message:
    "The value of the attribute `linter.flake8.plugins` in your `sideci.yml` is invalid. Please fix and retry.",
  analyzer: :_
)
