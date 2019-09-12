NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app.php",
      location: { :start_line => 18 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: []
    }
  ],
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  },
})

NodeHarness::Testing::Smoke.add_test("specified_dir", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app/app.php",
      location: { :start_line => 6 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: []
    }
  ],
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  },
}, warnings: [{ :message => "`dir` key under the `options` is deprecated. Please declare it just under the `code_sniffer`. See https://help.sider.review/tools/php/codesniffer#options", :file => "sideci.yml" }])

# Regression test for large output
# See https://github.com/sideci/runner_code_sniffer/pull/27
NodeHarness::Testing::Smoke.add_test("sideci_php_sandbox", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: :_,
    analyzer: {
        name: "code_sniffer",
        version: "3.4.2"
    },
})

NodeHarness::Testing::Smoke.add_test("with_php_version", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: :_,
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  }
})

NodeHarness::Testing::Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  analyzer: nil,
  message: "Invalid configuration in `sideci.yml`: unknown attribute at config: `$.linter.code_sniffer.options`"
})

NodeHarness::Testing::Smoke.add_test("version_2", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app.php",
      location: { :start_line => 18 },
      id: "PSR2.Files.ClosingTag.NotAllowed",
      message: "A closing tag is not permitted at the end of a PHP file",
      links: []
    }
  ],
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  },
},
warnings: [{
  message: "Sider has no longer supported PHP_CodeSniffer v2. Sider executes v3 even if putting `2` as `version` option.",
  file: "sider.yml"
}])

require_relative 'phpcs3/expectations.rb'
