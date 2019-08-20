NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { :start_line => 4, :start_column => 0, :end_line => 4, :end_column => 19},
      id: "com.method_chain",
      object: {
        :id => "com.method_chain",
        :messages => ["Method chain with `_`.\n" + "\n" + "message...\n"],
        :justifications => [],
        :examples => []
      },
    },
    { path: "foo.rb",
      location: { :start_line => 1, :start_column => 7, :end_line => 1, :end_column => 34 },
      id: "com.test.pathname",
      object: { :id => "com.test.pathname",
                :messages => ["Use Pathname method instead"],
                :justifications => ["Want to write this code."],
                :examples => [
                  {
                    before: "Pathname.new(\"path\")",
                    after: "Pathname(\"path\")"
                  }
                ] } }
  ],
  analyzer: {
    name: "querly",
    version: "1.0.0"
  }
})

NodeHarness::Testing::Smoke.add_test("no_config_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: {
    name: "querly",
    version: "1.0.0",
  }
}, warnings: [
  { message: <<~MESSAGE, file: nil }
    Sider cannot find the required configuration file `querly.yml`.
    Please set up Querly by following the instructions, or you can disable it in the repository settings.

    - https://github.com/soutaro/querly
    - https://help.sider.review/tools/ruby/querly
  MESSAGE
])

NodeHarness::Testing::Smoke.add_test("invalid_config_file", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "foo.rb",
      location: { :start_line => 1, :start_column => 7, :end_line => 1, :end_column => 34 },
      id: "com.test.pathname",
      object: { :id => "com.test.pathname",
                :messages => ["Use Pathname method instead"],
                :justifications => [],
                :examples => [] } }
  ],
  analyzer: {
    name: "querly",
    version: "1.0.0"
  }
}, warnings: [
  {message: "com.test.pathname:\t1st *after* example matched with some of patterns", file: 'querly.yml'},
])

NodeHarness::Testing::Smoke.add_test("slim", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      path: "hello.slim",
      location: { start_line: 1, start_column: :_, end_line: 1, end_column: :_ },
      id: "link_to",
      object: {
        id: "link_to",
        messages: ["link_to\n\nSome message.\n"],
        justifications: [],
        examples: [],
      }
    }
  ],
  analyzer: {
    name: "querly",
    version: "1.0.0"
  }
})

NodeHarness::Testing::Smoke.add_test("haml", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      path: "test.html.haml",
      location: { start_line: 2, start_column: :_, end_line: 2, end_column: :_ },
      id: "link_to",
      object: {
        id: "link_to",
        messages: ["link_to\n\nSome message.\n"],
        justifications: [],
        examples: [],
      }
    }
  ],
  analyzer: {
    name: "querly",
    version: "1.0.0"
  }
})

NodeHarness::Testing::Smoke.add_test("lowest_deps", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "foo.rb",
      location: { :start_line => 1, :start_column => 7, :end_line => 1, :end_column => 34 },
      id: "com.test.pathname",
      object: { :id => "com.test.pathname",
                :messages => ["Use Pathname method instead"],
                :justifications => ["Want to write this code."],
                :examples => [
                  {
                    before: "Pathname.new(\"path\")",
                    after: "Pathname(\"path\")"
                  }
                ] } }
  ],
  analyzer: {
    name: "querly",
    version: "0.5.0"
  }
})
