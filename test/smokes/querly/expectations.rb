s = Runners::Testing::Smoke

default_version = "1.1.0"

s.add_test(
  "success",
  timestamp: :_,
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { start_line: 4, start_column: 0, end_line: 4, end_column: 19 },
      id: "com.method_chain",
      message: "Method chain with `_`.\n" + "\n" + "message...\n",
      links: [],
      object: {
        id: "com.method_chain",
        messages: ["Method chain with `_`.\n" + "\n" + "message...\n"],
        justifications: [],
        examples: []
      },
      git_blame_info: nil
    },
    {
      path: "foo.rb",
      location: { start_line: 1, start_column: 7, end_line: 1, end_column: 34 },
      id: "com.test.pathname",
      message: "Use Pathname method instead",
      links: [],
      object: {
        id: "com.test.pathname",
        messages: ["Use Pathname method instead"],
        justifications: ["Want to write this code."],
        examples: [{ before: 'Pathname.new("path")', after: 'Pathname("path")' }]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: default_version }
)

s.add_test(
  "no_config_file",
  type: "success",
  issues: [],
  analyzer: { name: "Querly", version: default_version },
  warnings: [
    {
      message: <<~MESSAGE.strip,
        Sider could not find the required configuration file `querly.yml`.
        Please create the file according to the following documents:
        - https://github.com/soutaro/querly
        - https://help.sider.review/tools/ruby/querly
      MESSAGE
      file: "querly.yml"
    }
  ]
)

s.add_test(
  "invalid_config_file",
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { start_line: 1, start_column: 7, end_line: 1, end_column: 34 },
      id: "com.test.pathname",
      message: "Use Pathname method instead",
      links: [],
      object: { id: "com.test.pathname", messages: ["Use Pathname method instead"], justifications: [], examples: [] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: default_version },
  warnings: [{ message: "com.test.pathname:\t1st *after* example matched with some of patterns", file: "querly.yml" }]
)

s.add_test(
  "slim",
  type: "success",
  issues: [
    {
      path: "hello.slim",
      location: { start_line: 1, start_column: :_, end_line: 1, end_column: :_ },
      id: "link_to",
      message: "link_to\n\nSome message.\n",
      links: [],
      object: { id: "link_to", messages: ["link_to\n\nSome message.\n"], justifications: [], examples: [] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: default_version }
)

s.add_test(
  "haml",
  type: "success",
  issues: [
    {
      path: "test.html.haml",
      location: { start_line: 2, start_column: :_, end_line: 2, end_column: :_ },
      id: "link_to",
      message: "link_to\n\nSome message.\n",
      links: [],
      object: { id: "link_to", messages: ["link_to\n\nSome message.\n"], justifications: [], examples: [] },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: default_version }
)

s.add_test(
  "lowest_deps",
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { start_line: 1, start_column: 7, end_line: 1, end_column: 34 },
      id: "com.test.pathname",
      message: "Use Pathname method instead",
      links: [],
      object: {
        id: "com.test.pathname",
        messages: ["Use Pathname method instead"],
        justifications: ["Want to write this code."],
        examples: [{ before: 'Pathname.new("path")', after: 'Pathname("path")' }]
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: "0.5.0" }
)

s.add_test(
  "option_config",
  type: "success",
  issues: [
    {
      path: "foo.rb",
      location: { start_line: 1, start_column: 0, end_line: 1, end_column: 6 },
      id: "rule.foo",
      message: "Check `foo` method",
      links: [],
      object: {
        id: "rule.foo",
        messages: ["Check `foo` method"],
        justifications: [],
        examples: []
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: default_version }
)

s.add_test(
  "duplicate_config_files",
  type: "success",
  issues: [
    {
      path: "test.rb",
      location: { start_line: 1, start_column: 0, end_line: 1, end_column: 5 },
      id: "foo",
      message: "Disallow `foo`",
      links: [],
      object: {
        id: "foo",
        messages: ["Disallow `foo`"],
        justifications: [],
        examples: []
      },
      git_blame_info: nil
    }
  ],
  analyzer: { name: "Querly", version: default_version },
  warnings: [
    {
      message: "There are duplicate configuration files (`querly.yml`, `querly.yaml`). Remove the files except the first one.",
      file: "querly.yml"
    }
  ]
)
