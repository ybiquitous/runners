# NodeHarness

[![Build Status](https://travis-ci.com/sider/node_harness.svg?token=z7WQGZviWBM4zmGAt52E&branch=master)](https://travis-ci.com/sider/node_harness)

[Setaria](https://github.com/sider/setaria) Analyzer Framework.

## Table of Contents

1. [Terminology](#terminology)
1. [Preparation](#preparation)
1. [Writing New Runner](#writing-new-runner)
1. [Programmatic API](#programmatic-api)
1. [Release NodeHarness](#release-nodeharness)
1. [Update Runners](#update-runners)
1. [Update and Deploy Setaria](#update-and-deploy-setaria)

## Terminology

| Term            | Definition                                                                            |
| --------------- | ------------------------------------------------------------------------------------- |
| **NodeHarness** | This library.                                                                         |
| **Runner**      | The set of scripts and `Dockerfile` to define docker image providing API for Setaria. |
| **Analyzer**    | The tool which will execute your intended analysis, invoked by Runner.                |

## Preparation

After you checkout the source code, install required gems at first.

```
$ bundle install
```

Next, install Node.js, npm and Yarn also. We recommend [`nvm`](https://github.com/nvm-sh/nvm) which can manage different Node.js versions. If you use unexpected `node`, `npm` and `yarn` versions, the tests will fail.

```
$ nvm install
```

```
$ npm install -g npm@<required_npm_version>
```

```
$ npm install -g yarn@<required_yarn_version>
```

## Writing New Runner

### 1. Run generate command

```
$ bundle exec runner generate runner_rubocop
```

### 2. Setup

```
$ mv runner_rubocop /path/to/runner_rubocop
$ cd /path/to/runner_rubocop
$ git init
$ bundle install
```

### 3. Create a repository to GitHub

- Create a runner repository from https://github.com/organizations/sider/repositories/new
- Setup Slack integration (e.g. `/github subscribe sider/runner_rubocop`)
- Setup Travis CI from https://travis-ci.com/profile/sider
- Setup quay.io from https://quay.io/new/

### 4. Add Runner entry point

Add a ruby script to define analyzer, typically will be `lib/entrypoint.rb`.
The entry point would do the following:

1. Define `Processor` class; a subclass of [`NodeHarness::Processor`](lib/node_harness/processor.rb)
2. Register the class to `NodeHarness`

### 5. Dockerize

Edit `Dockerfile` to install analyzer. Also, select build pack docker image.
After edited, build runner image for development.

```
$ bundle exec rake docker:build
```

If you want to enter into the container, you can run the following commandline:

```
$ bundle exec rake docker:shell
```

### 6. Testing

#### By Hand

On the early stage of development, running the tool and see the output will help you very much.
Typical test run would be the following:

```
$ bundle exec node_harness --entrypoint=lib/entrypoint.rb test-guid path/to/sample/program
```

#### Unit Test

Unit test allows you to test your processor.

```ruby
require_relative "test_helper"

class ProcessorTest < Minitest::Test
  include TestHelper

  def test_something
    processor source_dir_path: Pathname(__dir__) do |processor|
      # do any test using the processor
    end
  end
end
```

You can test any methods defined in the processor.
Writing test friendly processor will be a great help for you.

If you want to run the unit tests within a container. Run `bundle exec rake docker:test`

#### Smoke Test

Smoke test allows testing by input and output of the analysis.

Put a set of files in a directory, and write `expectations.rb` to define the expected output.

```ruby
NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "foo.rb",
      location: { :start_line => 1, :start_column => 7, :end_line => 1, :end_column => 34 },
      id: "com.test.pathname",
      object: { :id => "com.test.pathname",
                :messages => ["Use Pathname method instead"],
                :justifications => [] } }
  ]
})
```

Use [`NodeHarness::Testing::Smoke.add_test`](lib/node_harness/testing/smoke.rb) method to define name of test and expected pattern.
The pattern is defined by `UnificationAssertion`. However it is possible to use Regexp in the pattern like the following:

```ruby
NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: []
}, warnings: [
  { message: /Invalid configuration found in/ }
])
```

Run smoke test by the following command-line:

```
$ bundle exec rake test:smoke
```

The following environment variables are available during the smoke test:

| Name         | Description                                                           |
| ------------ | --------------------------------------------------------------------- |
| `ONLY`       | Run only specific test.                                               |
| `SHOW_TRACE` | If `true`, output traces to stdout while running test.                |
| `JOBS`       | Control the number of parallels. Default is twice the number of CPUs. |

If you want to run the smoke tests within a container. Run `bundle exec rake docker:smoke`

## Programmatic API

- [`NodeHarness::Processor`](lib/node_harness/processor.rb)
- [`NodeHarness::Results`](lib/node_harness/results.rb)
- [`NodeHarness::Issues`](lib/node_harness/issues.rb)
- [`NodeHarness::Ruby`](lib/node_harness/ruby.rb)
- [`NodeHarness::Testing::Smoke`](lib/node_harness/testing/smoke.rb)

## Release NodeHarness

`VERSION` is actually one which you are going to update to (e.g. `1.3.0`, `2.0.1`).

1. Update `VERSION` in [`lib/node_harness/version.rb`](lib/node_harness/version.rb) file.
1. Run `git commit -m 'Bump up version to VERSION'` command.
1. Run `bundle exec rake release` command (tag & push).
1. If you want, please edit manually [the release page](https://github.com/sider/node_harness/releases/latest).
    - However, if there are **BREAKING CHANGES** in the new version, then it's strongly **RECOMMENDED** to edit.

Next, you will update the version of NodeHarness which each runner depends on.

## Update Runners

Mainly you will use `nekonote runner` command.
For details about this command, please see [documentation](https://github.com/sider/nekonote#runner).

Run this command when updating specific runners:

E.g.

```
$ nekonote runner update --tag=v2.0.1 runner_rubocop runner_eslint [...]
```

The `nekonote runner update` command pushes commit to update NodeHarness.

Next steps:

1. Open pull request including the commit.
1. Get reviews.
1. Merge the pull request.

Next, you should publish runners via `nekonote runner publish` command:

E.g.

```
$ nekonote runner publish [--patch] runner_rubocop runner_eslint [...]
```

You can give the following options:

- `--patch` (default)
- `--minor`
- `--major`

Next, you will update Setaria which depends on the updated runner(s).

## Update and Deploy Setaria

*Assume that you already have cloned the Setaria repository to your machine.*

Follow each step:

1. Move to your local Setaria directory.
1. Run `git checkout master` command.
1. Run `git pull origin master` command.
    - That is, make your local `master` branch up-to-date.
1. Run `bundle exec rake runner:update` command.
    - For details, see Setaria [`Rakefile`](https://github.com/sider/setaria/blob/master/Rakefile#L118).
1. Commit file(s) updated via the command.
1. Open pull request including the commit.
1. Get reviews.
1. Merge the pull request.
1. Deploy on [Jenkins](https://jenkins.sideci.com/).
