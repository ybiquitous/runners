# Sider Runners

[![CircleCI](https://circleci.com/gh/sider/runners.svg?style=svg)](https://circleci.com/gh/sider/runners)

This is a Sider analyzer framework.

See also another related project, called [devon_rex](https://github.com/sider/devon_rex).

## Supported analyzers

*(in alphabetical order)*

- Brakeman
- Checkstyle
- CoffeeLint
- Cppcheck
- cpplint
- ESLint
- Flake8
- go vet
- Golint
- Go Meta Linter
- Goodcheck
- HAML-Lint
- JSHint
- JavaSee
- ktlint
- Misspell
- PHPMD
- PHP_CodeSniffer
- PMD Java
- Phinder
- Querly
- Rails Best Practices
- Reek
- RuboCop
- SCSS-Lint
- ShellCheck
- stylelint
- SwiftLint
- TSLint
- TyScan

## Testing

You can run smoke tests via the `rake docker:smoke` command as follow:

```shell
$ bundle exec rake docker:build
$ bundle exec rake docker:smoke ANALYZER=some_analyzer [ONLY=test1,test2,...] [SHOW_TRACE=true]
```

- `ONLY`: Specify test name(s). You can specify a comma-separated list.
- `SHOW_TRACE`: Show trace log to console. Useful to debug.

## License

See [LICENSE](LICENSE).
