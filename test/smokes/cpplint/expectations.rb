Smoke = Runners::Testing::Smoke

Smoke.add_test("default", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "legal/copyright",
      path: "src/test.cpp",
      location: nil,
      message: 'No copyright message found.  You should have a line: "Copyright [year] <Copyright Owner>"',
      links: [],
      object: {
        confidence: "5",
      },
    },
    {
      id: "whitespace/braces",
      path: "foo.cc",
      location: { start_line: 3 },
      message: "{ should almost always be at the end of the previous line",
      links: [],
      object: {
        confidence: "4",
      },
    },
    {
      id: "whitespace/tab",
      path: "foo.cc",
      location: { start_line: 4 },
      message: "Tab found; better to use spaces",
      links: [],
      object: {
        confidence: "1",
      },
    },
  ],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("official_samples", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: :_,
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_exclude", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_exclude_multi", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_extensions", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_filter", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "whitespace/braces",
      path: "test.cpp",
      location: { start_line: 2 },
      message: "{ should almost always be at the end of the previous line",
      links: [],
      object: {
        confidence: "4",
      },
    },
  ],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_headers", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_linelength", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "whitespace/line_length",
      path: "test.cpp",
      location: nil,
      message: "Lines should be <= 50 characters long",
      links: [],
      object: {
        confidence: "2",
      },
    },
    {
      id: "whitespace/line_length",
      path: "test.cpp",
      location: { start_line: 2 },
      message: "Lines should be <= 50 characters long",
      links: [],
      object: {
        confidence: "2",
      },
    },
  ],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_target", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "whitespace/braces",
      path: "src/foo.cpp",
      location: { start_line: 2 },
      message: "Missing space before {",
      links: [],
      object: {
        confidence: "5",
      },
    },
  ],
  analyzer: { name: "cpplint", version: "1.4.4" },
})

Smoke.add_test("option_target_multi", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "whitespace/braces",
      path: "lib/bar.cc",
      location: { start_line: 2 },
      message: "Missing space before {",
      links: [],
      object: {
        confidence: "5",
      },
    },
    {
      id: "whitespace/braces",
      path: "src/foo.cpp",
      location: { start_line: 2 },
      message: "Missing space before {",
      links: [],
      object: {
        confidence: "5",
      },
    },
  ],
  analyzer: { name: "cpplint", version: "1.4.4" },
})
