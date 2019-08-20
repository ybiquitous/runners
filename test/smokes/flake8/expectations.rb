NodeHarness::Testing::Smoke.add_test(
  'sandbox_django',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: "app1/views.py",
      location: {
        start_line: 6
      },
      id: "E999",
      message: "[E999] IndentationError: unexpected indent",
      links: []
    },
    {
      path: "app1/admin.py",
      location: {
        start_line: 1
      },
      id: "F401",
      message: "[F401] 'django.contrib.admin' imported but unused",
      links: []
    },
    {
      path: "app1/tests.py",
      location: {
        start_line: 1
      },
      id: "F401",
      message: "[F401] 'django.test.TestCase' imported but unused",
      links: []
    },
    {
      path: "manage.py",
      location: {
        start_line: 14
      },
      id: "F401",
      message: "[F401] 'django' imported but unused",
      links: []
    },
    {
      path: 'app1/models.py',
      location: {
        start_line: 15,
      },
      id: 'F601',
      message: "[F601] dictionary key 'name' repeated with different values",
      links: [],
    },
    {
      path: 'app1/models.py',
      location: {
        start_line: 16,
      },
      id: 'F601',
      message: "[F601] dictionary key 'name' repeated with different values",
      links: [],
    },
    {
      path: "app1/models.py",
      location: {
        start_line: 12
      },
      id: "F821",
      message: "[F821] undefined name 'ok'",
      links: []
    },
    {
      path: "app1/models.py",
      location: {
        start_line: 13
      },
      id: "F841",
      message: "[F841] local variable 'foo' is assigned to but never used",
      links: []
    },
  ],
  analyzer: {
    name: "Flake8",
    version: "3.7.7"
  }
)

NodeHarness::Testing::Smoke.add_test(
  'user_config_enabled',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: "foo.py",
      location: {
        start_line: 2
      },
      id: "E117",
      links: [],
      message: "[E117] over-indented",
    },
    {
      path: "foo.py",
      location: {
        start_line: 2
      },
      id: "W191",
      message: "[W191] indentation contains tabs",
      links: []
    }
  ],
  analyzer: {
    name: "Flake8",
    version: "3.7.7"
  }
)

NodeHarness::Testing::Smoke.add_test(
  'no_user_config_enabled',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [],  # W191 is not issued.
  analyzer: {
    name: "Flake8",
    version: "3.7.7"
  }
)

NodeHarness::Testing::Smoke.add_test(
  'with_plugins',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {
      path: "foo.py",
      location: {
        start_line: 2
      },
      id: "A001",
      message: '[A001] "id" is a python builtin and is being shadowed, consider renaming the variable',
      links: []
    }
  ],
  analyzer: {
    name: "Flake8",
    version: "3.7.7"
  }
)

NodeHarness::Testing::Smoke.add_test(
  'with_output_options',
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    {:message=>"[E302] expected 2 blank lines, found 1",
     :links=>[],
     :id=>"E302",
     :path=>"foo.py",
     :location=>{:start_line=>4},
    },
    {:message=>"[F841] local variable 'a' is assigned to but never used",
     :links=>[],
     :id=>"F841",
     :path=>"foo.py",
     :location=>{:start_line=>5},
    },
    {:message=>"[F841] local variable 'b' is assigned to but never used",
     :links=>[],
     :id=>"F841",
     :path=>"foo.py",
     :location=>{:start_line=>6},
    },
    {:message=>"[W391] blank line at end of file",
     :links=>[],
     :id=>"W391",
     :path=>"foo.py",
     :location=>{:start_line=>8},
    },
  ],
  analyzer: {
    name: "Flake8",
    version: "3.7.7"
  }
)

NodeHarness::Testing::Smoke.add_test("broken_sideci_yml", {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "Invalid configuration in sideci.yml: unexpected value at config: $.linter.flake8.plugins",
  analyzer: nil
})
