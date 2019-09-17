Smoke = Runners::Testing::Smoke

Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app.php",
      location: { :start_line => 5, :end_line => 5 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$hoge'.",
      links: ["http://phpmd.org/rules/unusedcode.html#unusedlocalvariable"]
    }
  ],
  analyzer: {
    name: "phpmd",
    version: "2.6.1"
  },
})

Smoke.add_test("invalid_rule", {
  guid: "test-guid",
  timestamp: :_,
  type: "error",
  class: "Runners::Shell::ExecError",
  backtrace: :_,
  inspect: :_
})

Smoke.add_test("valid_options", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app/index.php",
      location: { :start_line => 20, :end_line => 20 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$hoge'.",
      links: ["http://phpmd.org/rules/unusedcode.html#unusedlocalvariable"]
    }
  ],
  analyzer: {
    name: "phpmd",
    version: "2.6.1"
  },
})

Smoke.add_test("syntax_error", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: :_,
  analyzer: {
    name: "phpmd",
    version: "2.6.1",
  },
})

Smoke.add_test("php_7.1", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "SomeClass.php",
      location: { :start_line => 11, :end_line => 11 },
      id: "UnusedPrivateField",
      message: "Avoid unused private fields such as '$unusedVariable'.",
      links: ["http://phpmd.org/rules/unusedcode.html#unusedprivatefield"],
    },
  ],
  analyzer: {
    name: "phpmd",
    version: "2.6.1",
  }
})

Smoke.add_test("php_7.3", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app.php",
      location: { :start_line => 7, :end_line => 7 },
      id: "UnusedLocalVariable",
      message: "Avoid unused local variables such as '$hoge'.",
      links: ["http://phpmd.org/rules/unusedcode.html#unusedlocalvariable"]
    }
  ],
  analyzer: {
    name: "phpmd",
    version: "2.6.1"
  },
})

Smoke.add_test("with_php_version", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: {
    name: "phpmd",
    version: "2.6.1",
  }
})

Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.phpmd.minimumpriority`",
  analyzer: nil
})
