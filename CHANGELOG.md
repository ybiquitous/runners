# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

[Full diff](https://github.com/sider/runners/compare/0.0.7...HEAD)

- Rename namespace: `NodeHarness` -> `Runners` [#96](https://github.com/sider/runners/pull/96)
- Install default npm tools via `package.json` [#99](https://github.com/sider/runners/pull/99)
- Set Bundler config: `jobs`, `retry` [#107](https://github.com/sider/runners/pull/107)
- Change owner and group of runner's home directory [#109](https://github.com/sider/runners/pull/109)
- Remove useless `BUNDLE_GEMFILE` from `Dockerfile` [#122](https://github.com/sider/runners/pull/122)
- Install default gems via `Gemfile` [#110](https://github.com/sider/runners/pull/110)
- Use Pipenv to address the dependency of Flake8 [#111](https://github.com/sider/runners/pull/111)
- Normalize version strings of Go tools [#123](https://github.com/sider/runners/pull/123)

## 0.0.7

[Full diff](https://github.com/sider/runners/compare/0.0.6...0.0.7)

- Show Node.js runtime versions [#83](https://github.com/sider/runners/pull/83)
- Improve error message when `root_dir` is not found [#84](https://github.com/sider/runners/pull/84)
- Improve messages in markdown format [#85](https://github.com/sider/runners/pull/85)
- Show Ruby runtime versions [#87](https://github.com/sider/runners/pull/87)
- Bump devon_rex images from 2.1.0 to 2.2.0 [#89](https://github.com/sider/runners/pull/89)
- Fix `stylelint-config-recommended` version [#93](https://github.com/sider/runners/pull/93)

## 0.0.6

[Full diff](https://github.com/sider/runners/compare/0.0.5...0.0.6)

- Bump devon_rex images from 2.0.3 to 2.1.0 [#75](https://github.com/sider/runners/pull/75)
