NodeHarness::Testing::Smoke.add_test(
  "default",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      message: "Array 'a[2]' accessed at index 2, which is out of bounds. (error)",
      path: "arrayIndexOutOfBounds.c",
      location: { start_line: 7 },
      links: [],
    },
    {
      id: "autoVariables",
      message: "Address of local auto-variable assigned to a function parameter. (error)",
      path: "autoVariables.c",
      location: { start_line: 4 },
      links: [],
    },
    {
      id: "memleak",
      message: "Memory leak: p (error)",
      path: "src/memleak.cpp",
      location: { start_line: 4 },
      links: [],
    },
    {
      id: "syntaxError",
      message: "Unmatched '{'. Configuration: ''. (error)",
      path: "src/syntaxError.c",
      location: { start_line: 2 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "no_target",
  guid: "test-guid",
  timestamp: :_,
  type: "error",
  class: "NodeHarness::Shell::ExecError",
  backtrace: :_,
  inspect: :_,
)

NodeHarness::Testing::Smoke.add_test(
  "single_target",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "autoVariables",
      message: "Address of local auto-variable assigned to a function parameter. (error)",
      path: "autoVariables.c",
      location: { start_line: 4 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "multiple_target",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      message: "Array 'a[2]' accessed at index 2, which is out of bounds. (error)",
      path: "src/arrayIndexOutOfBounds.c",
      location: { start_line: 7 },
      links: [],
    },
    {
      id: "autoVariables",
      message: "Address of local auto-variable assigned to a function parameter. (error)",
      path: "autoVariables.c",
      location: { start_line: 4 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "single_ignore",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      message: "Array 'a[2]' accessed at index 2, which is out of bounds. (error)",
      path: "arrayIndexOutOfBounds.c",
      location: { start_line: 7 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "multiple_ignore",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "syntaxError",
      message: "Unmatched '{'. Configuration: ''. (error)",
      path: "syntaxError.c",
      location: { start_line: 2 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "enable",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "readWriteOnlyFile",
      message: "Read operation on a file that was opened only for writing. (error)",
      path: "bad.c",
      location: { start_line: 5 },
      links: [],
    },
    {
      id: "seekOnAppendedFile",
      message: "Repositioning operation performed on a file opened in append mode has no effect. (warning)",
      path: "bad.c",
      location: { start_line: 4 },
      links: [],
    },
    {
      id: "unusedFunction",
      message: "The function 'foo' is never used. (style)",
      path: "bad.c",
      location: { start_line: 1 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "std",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "allocaCalled",
      message: "Obsolete function 'alloca' called. In C99 and later it is recommended to use a variable length array instead. (warning)",
      path: "bad.c",
      location: { start_line: 2 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "project",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "zerodiv",
      message: "Division by zero. (error)",
      path: "main.c",
      location: { start_line: 5 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

NodeHarness::Testing::Smoke.add_test(
  "language",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      message: "Array 'a[1]' accessed at index 1, which is out of bounds. (error)",
      path: "bad.c",
      location: { start_line: 4 },
      links: [],
    },
    {
      id: "syntaxError",
      message: "Code 'std::vector' is invalid C code. Use --std or --language to configure the language. (error)",
      path: "bad.cpp",
      location: { start_line: 4 },
      links: [],
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)
