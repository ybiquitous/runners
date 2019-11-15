# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

[Full diff](https://github.com/sider/runners/compare/0.9.1...HEAD)

- Flush content whenever its size reaches the buffer max limit [#497](https://github.com/sider/runners/pull/497)

## 0.9.1

[Full diff](https://github.com/sider/runners/compare/0.9.0...0.9.1)

- [RuboCop] Fix `Ruby#installed_gem_versions` [#489](https://github.com/sider/runners/pull/489)

## 0.9.0

[Full diff](https://github.com/sider/runners/compare/0.8.2...0.9.0)

- Update scss_lint from 0.58.0 to 0.59.0 [#432](https://github.com/sider/runners/pull/432)
- Bump pmd_java from 6.18.0 to 6.19.0 [#433](https://github.com/sider/runners/pull/433)
- Bump flake8 from 3.7.8 to 3.7.9 [#436](https://github.com/sider/runners/pull/436)
- Bump haml_lint from 0.33.0 to 0.34.0 [#440](https://github.com/sider/runners/pull/440)
- Bump checkstyle from 8.25 to 8.26 [#441](https://github.com/sider/runners/pull/441)
- Bump ktlint from 0.34.2 to 0.35.0 [#442](https://github.com/sider/runners/pull/442)
- Bump php_codesniffer from 3.5.0 to 3.5.2 [#444](https://github.com/sider/runners/pull/444)
- Bump tslint from 5.20.0 to 5.20.1 [#469](https://github.com/sider/runners/pull/469)
- Bump eslint from 6.5.1 to 6.6.0 [#431](https://github.com/sider/runners/pull/431)
- Bump goodcheck from 2.4.0 to 2.4.3 [#468](https://github.com/sider/runners/pull/468)
- Bump rubocop from 0.75.0 to 0.76.0 [#434](https://github.com/sider/runners/pull/434)
- Bump devon_rex images from 2.7.0 to 2.8.0 [#474](https://github.com/sider/runners/pull/474)
- Bump SwiftLint from 0.36.0 to 0.37.0 [#473](https://github.com/sider/runners/pull/473)
- [RuboCop] Empower runner [#472](https://github.com/sider/runners/pull/472)
- [checkstyle] Empower runner [#475](https://github.com/sider/runners/pull/475)
- [SwiftLint] Show a warning when no linting files [#478](https://github.com/sider/runners/pull/478)
- Bump JavaSee from 0.1.2 to 0.1.3 [#479](https://github.com/sider/runners/pull/479)
- Bump stylelint from 11.0.0 to 11.1.1 [#438](https://github.com/sider/runners/pull/438)
- [Cppcheck] Show warning and succeed when no linting files [#480](https://github.com/sider/runners/pull/480)
- Deprecate `linter.*.options` option [#482](https://github.com/sider/runners/pull/482)

## 0.8.2

[Full diff](https://github.com/sider/runners/compare/0.8.1...0.8.2)

- Add Runners version and set it to result [#449](https://github.com/sider/runners/pull/449)
- Always output the exit status to trace [#451](https://github.com/sider/runners/pull/451)
- Configure :endpoint if S3_ENDPOINT is set [#462](https://github.com/sider/runners/pull/462)

## 0.8.1

[Full diff](https://github.com/sider/runners/compare/0.8.0...0.8.1)

- [ESLint] Fix type error when no location info [#456](https://github.com/sider/runners/pull/456)

## 0.8.0

[Full diff](https://github.com/sider/runners/compare/0.7.5...0.8.0)

- Bugsnag notify on `rescue` block [#445](https://github.com/sider/runners/pull/445)
- [stylelint] Empower runner [#420](https://github.com/sider/runners/pull/420)
- [cpplint] New support [#417](https://github.com/sider/runners/pull/417)
- **[BREAKING]** Add Options module and delete insecure options [#415](https://github.com/sider/runners/pull/415)
- Output an unexpected error message to the trace log [#446](https://github.com/sider/runners/pull/446)
- [ESLint] Use `--output-file` option to fix JSON parse error [#447](https://github.com/sider/runners/pull/447)
- Suppress `npm ls` output [#448](https://github.com/sider/runners/pull/448)

## 0.7.5

[Full diff](https://github.com/sider/runners/compare/0.7.4...0.7.5)

- Improve deprecation message for older versions [#419](https://github.com/sider/runners/pull/419)
- [SwiftLint] Treat as success when no linting files [#422](https://github.com/sider/runners/pull/422)
- [JSHint] Improve error message when output XML parse is failed [#423](https://github.com/sider/runners/pull/423)

## 0.7.4

[Full diff](https://github.com/sider/runners/compare/0.7.3...0.7.4)

- Report message and metadata on `Shell::ExecError` to Bugsnag [#414](https://github.com/sider/runners/pull/414)
- Fix error for issue sorting when location is nil [#416](https://github.com/sider/runners/pull/416)

## 0.7.3

[Full diff](https://github.com/sider/runners/compare/0.7.2...0.7.3)

- Remove a warning for Node.js analyzers without dependencies [#410](https://github.com/sider/runners/pull/410)

## 0.7.2

[Full diff](https://github.com/sider/runners/compare/0.7.1...0.7.2)

- [JSHint] Show runtime versions [#407](https://github.com/sider/runners/pull/407)
- Copy `ARGV` for notifying to Bugsnag correctly [#408](https://github.com/sider/runners/pull/408)

## 0.7.1

[Full diff](https://github.com/sider/runners/compare/0.7.0...0.7.1)

- Set Bugsnag `release_stage` explicitly [#404](https://github.com/sider/runners/pull/404)
- Improve Bugsnag settings [#405](https://github.com/sider/runners/pull/405)
- [ESLint] Allow `recommended` as string [#406](https://github.com/sider/runners/pull/406)

## 0.7.0

[Full diff](https://github.com/sider/runners/compare/0.6.0...0.7.0)

- [JSHint] Consider broken package.json [#327](https://github.com/sider/runners/pull/327)
- Bump devon_rex images from master to 2.6.0 and bump Ruby from 2.6.4 to 2.6.5 [#332](https://github.com/sider/runners/pull/332)
- Trap SIGTERM to exit with an arbitrary status [#344](https://github.com/sider/runners/pull/344)
- Bump JavaSee from 0.1.1 to 0.1.2 [#362](https://github.com/sider/runners/pull/362)
- Optimize generated Gemfile [#359](https://github.com/sider/runners/pull/359)
- Use `COPY --chown` format in Dockerfile [#369](https://github.com/sider/runners/pull/369)
- Use pre-installed gems as possible [#367](https://github.com/sider/runners/pull/367)
- Bump SwiftLint from 0.34.0 to 0.36.0 [#363](https://github.com/sider/runners/pull/363)
- Bump devon_rex images from 2.6.0 to 2.7.0 (many PRs!)
- Empower ESLint runner [#401](https://github.com/sider/runners/pull/401)

## 0.6.0

[Full diff](https://github.com/sider/runners/compare/0.5.2...0.6.0)

- Reconsider issue data structure [#313](https://github.com/sider/runners/pull/313)
- Fix PHPMD target files with `suffixes` option [#318](https://github.com/sider/runners/pull/318)
- Fix Checkstyle output XML parse error [#319](https://github.com/sider/runners/pull/319)
- Improve Goodcheck error message [#321](https://github.com/sider/runners/pull/321)
- Improve Checkstyle invalid XML error message [#322](https://github.com/sider/runners/pull/322)
- Improve PHPMD custom rule support [#323](https://github.com/sider/runners/pull/323)
- Make timeout(1) call SIGUSR2 and trap it in bin/runners [#320](https://github.com/sider/runners/pull/320)
- Bump devon_rex images from 2.4.0 to 2.5.0 [#324](https://github.com/sider/runners/pull/324)

## 0.5.2

[Full diff](https://github.com/sider/runners/compare/0.5.1...0.5.2)

- Notify exception if the result is "error" [#312](https://github.com/sider/runners/pull/312)
- Set ConnectTimeout for ssh(1) to avoid waiting for a long time [#309](https://github.com/sider/runners/pull/309)

## 0.5.1

[Full diff](https://github.com/sider/runners/compare/0.5.0...0.5.1)

- Add Bugsnag to notify any errors [#304](https://github.com/sider/runners/pull/304)
- Use timeout(1) to forcefully terminate too late Runners [#306](https://github.com/sider/runners/pull/306)

## 0.5.0

[Full diff](https://github.com/sider/runners/compare/0.4.1...0.5.0)

- Add ShellCheck runner [#289](https://github.com/sider/runners/pull/289)
- Install PHP_CodeSniffer and its dependencies via Composer [#290](https://github.com/sider/runners/pull/290)
- Bump phpmd/phpmd from 2.6.1 to 2.7.0 [#291](https://github.com/sider/runners/pull/291)
- Bump escapestudios/symfony2-coding-standard from 3.4.1 to 3.9.2 [#292](https://github.com/sider/runners/pull/292)
- Bump cakephp/cakephp-codesniffer from 3.1.1 to 3.1.2 [#293](https://github.com/sider/runners/pull/293)
- Bump wp-coding-standards/wpcs from 2.0.0 to 2.1.1 [#294](https://github.com/sider/runners/pull/294)
- Bump squizlabs/php_codesniffer from 3.4.2 to 3.5.0 [#295](https://github.com/sider/runners/pull/295)
- Bump all devon_rex images from 2.3.1 to 2.4.0 (see [changelog](https://github.com/sider/devon_rex/blob/master/CHANGELOG.md#240))

## 0.4.1

[Full diff](https://github.com/sider/runners/compare/0.4.0...0.4.1)

- Retrieve --head, --head-key, --base, and --base-key from env [#249](https://github.com/sider/runners/pull/249)

## 0.4.0

[Full diff](https://github.com/sider/runners/compare/0.3.1...0.4.0)

- Update eslint requirement from 5.16.0 to 6.4.0 [#100](https://github.com/sider/runners/pull/100)
- Show deprecation warning for too old ESLint [#209](https://github.com/sider/runners/pull/209)
- Update tslint requirement from 5.18.0 to 5.20.0 [#101](https://github.com/sider/runners/pull/101)
- Update typescript requirement from 3.5.3 to 3.6.3 [#104](https://github.com/sider/runners/pull/104)
- Bump default stylelint and stylelint-config-recommended [#210](https://github.com/sider/runners/pull/210)
- Add `.npmrc` for common settings [#211](https://github.com/sider/runners/pull/211)
- Update rubocop-rspec from 1.33.0 to 1.35.0 for HAML-Lint [#116](https://github.com/sider/runners/pull/116)
- Update typescript from 3.5.3 to 3.6.3 for TyScan [#103](https://github.com/sider/runners/pull/103)
- Update sass from 3.7.3 to 3.7.4 for rails_best_practices [#117](https://github.com/sider/runners/pull/117)
- Update scss_lint from 0.57.1 to 0.58.0 [#121](https://github.com/sider/runners/pull/121)
- Update rubocop from 0.71.0 to 0.74.0 for haml_lint [#115](https://github.com/sider/runners/pull/115)
- Update sassc from 2.0.1 to 2.2.1 for rails_best_practices [#119](https://github.com/sider/runners/pull/119)
- Bump flake8 from 3.7.7 to 3.7.8 [#124](https://github.com/sider/runners/pull/124)
- Update haml from 5.0.4 to 5.1.2 for rails_best_practices [#120](https://github.com/sider/runners/pull/120)
- Update haml_lint from 0.32.0 to 0.33.0 [#118](https://github.com/sider/runners/pull/118)
- Update tyscan from 0.2.1 to 0.3.1 [#212](https://github.com/sider/runners/pull/212)
- Bump checkstyle from 8.23 to 8.25 [#221](https://github.com/sider/runners/pull/221)
- Add "security" to the default rulesets of PMD Java [#226](https://github.com/sider/runners/pull/226)
- Bump pmd-java from 6.17.0 to 6.18.0 [#225](https://github.com/sider/runners/pull/225)
- Show Java runtime versions for Java based tools [#227](https://github.com/sider/runners/pull/227)
- Receive an SSH key with an environment variable [#206](https://github.com/sider/runners/pull/206)
- Add deprecation warning for too old RuboCop versions [#228](https://github.com/sider/runners/pull/228)
- Update rubocop-rails from 2.0.1 to 2.3.2 for haml_lint [#232](https://github.com/sider/runners/pull/232)
- Update rubocop-rspec from 1.35.0 to 1.36.0 for haml_lint [#233](https://github.com/sider/runners/pull/233)
- Update rubocop from 0.74.0 to 0.75.0 for haml_lint [#236](https://github.com/sider/runners/pull/236)
- Bump default eslint from 6.4.0 to 6.5.1 [#235](https://github.com/sider/runners/pull/235)
- Bump devon_rex images to 2.3.1 [#244](https://github.com/sider/runners/pull/244)
- Bump rubocop from 0.74.0 to 0.75.0 [#229](https://github.com/sider/runners/pull/229)

## 0.3.1

[Full diff](https://github.com/sider/runners/compare/0.3.0...0.3.1)

- Make #presence available [#204](https://github.com/sider/runners/pull/204)

## 0.3.0

[Full diff](https://github.com/sider/runners/compare/0.2.1...0.3.0)

- Add IO::AwsS3 to upload traces to AWS S3 [#162](https://github.com/sider/runners/pull/162)
- Fix ktlint bug [#201](https://github.com/sider/runners/pull/201)

## 0.2.1

[Full diff](https://github.com/sider/runners/compare/0.2.0...0.2.1)

- Fix missing ktlint settings in CircleCI [#198](https://github.com/sider/runners/pull/198)
- Fix ktlint bug [#201](https://github.com/sider/runners/pull/201)

## 0.2.0

[Full diff](https://github.com/sider/runners/compare/0.1.0...0.2.0)

- Fix `npm install` for TyScan [#163](https://github.com/sider/runners/pull/163)
- Support ktlint [#192](https://github.com/sider/runners/pull/192)
- Optimize Cppcheck Docker image via multi-stage [#195](https://github.com/sider/runners/pull/195)
- Bump devon_rex images from 2.2.0 to 2.2.2 (thanks to Dependabot!)

## 0.1.0

[Full diff](https://github.com/sider/runners/compare/0.0.7...0.1.0)

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
