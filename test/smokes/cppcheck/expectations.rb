Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "default",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "arrayIndexOutOfBounds.c",
      location: { start_line: 7 },
      message: "Array 'a[2]' accessed at index 2, which is out of bounds.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "788",
        location_info: "Array index out of bounds",
      },
    },
    {
      id: "autoVariables",
      path: "autoVariables.c",
      location: { start_line: 4 },
      message: "Address of local auto-variable assigned to a function parameter.",
      links: [],
      object: {
        severity: "error",
        verbose: /Dangerous assignment - the function parameter is assigned the address of a local auto-variable/,
        inconclusive: false,
        cwe: "562",
        location_info: nil,
      },
    },
    {
      id: "ctunullpointer",
      path: "src/nullpointer.c",
      location: { start_line: 2 },
      message: "Null pointer dereference: q",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "476",
        location_info: "Dereferencing argument q that is null",
      },
    },
    {
      id: "ctunullpointer",
      path: "src/nullpointer.c",
      location: { start_line: 6 },
      message: "Null pointer dereference: q",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "476",
        location_info: "Assignment 'a=0', assigned value is 0",
      },
    },
    {
      id: "ctunullpointer",
      path: "src/nullpointer.c",
      location: { start_line: 7 },
      message: "Null pointer dereference: q",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "476",
        location_info: "Calling function f, 1st argument is null",
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 4 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: "Variable created here.",
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 9 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: nil,
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 9 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: "Assuming condition is true.",
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 9 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: "Iterator to container is created here.",
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 10 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: "Assuming condition is true.",
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 10 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: "Assuming condition is true.",
      },
    },
    {
      id: "invalidContainer",
      path: "src/erase.cpp",
      location: { start_line: 11 },
      message: "Using iterator to local container 'items' that may be invalid.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: "After calling 'erase', iterators or references to the container's data may be invalid .",
      },
    },
    {
      id: "nullPointer",
      path: "src/nullpointer.c",
      location: { start_line: 2 },
      message: "Possible null pointer dereference: q",
      links: [],
      object: {
        severity: "warning",
        verbose: nil,
        inconclusive: false,
        cwe: "476",
        location_info: "Null pointer dereference",
      },
    },
    {
      id: "nullPointer",
      path: "src/nullpointer.c",
      location: { start_line: 6 },
      message: "Possible null pointer dereference: q",
      links: [],
      object: {
        severity: "warning",
        verbose: nil,
        inconclusive: false,
        cwe: "476",
        location_info: "Assignment 'a=0', assigned value is 0",
      },
    },
    {
      id: "nullPointer",
      path: "src/nullpointer.c",
      location: { start_line: 7 },
      message: "Possible null pointer dereference: q",
      links: [],
      object: {
        severity: "warning",
        verbose: nil,
        inconclusive: false,
        cwe: "476",
        location_info: "Calling function 'f', 1st argument 'a' value is 0",
      },
    },
    {
      id: "syntaxError",
      path: "src/syntaxError.c",
      location: { start_line: 2 },
      message: "Unmatched '{'. Configuration: ''.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: nil,
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test("no_target", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "Cppcheck", version: :_ },
}, {
  warnings: [{ message: "No linting files.", file: nil }],
})

Smoke.add_test(
  "single_target",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "autoVariables",
      path: "autoVariables.c",
      location: { start_line: 4 },
      message: "Address of local auto-variable assigned to a function parameter.",
      links: [],
      object: {
        severity: "error",
        verbose: /Dangerous assignment -/,
        inconclusive: false,
        cwe: "562",
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "multiple_target",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "src/arrayIndexOutOfBounds.c",
      location: { start_line: 7 },
      message: "Array 'a[2]' accessed at index 2, which is out of bounds.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "788",
        location_info: "Array index out of bounds",
      },
    },
    {
      id: "autoVariables",
      path: "autoVariables.c",
      location: { start_line: 4 },
      message: "Address of local auto-variable assigned to a function parameter.",
      links: [],
      object: {
        severity: "error",
        verbose: /Dangerous assignment -/,
        inconclusive: false,
        cwe: "562",
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "single_ignore",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "arrayIndexOutOfBounds.c",
      location: { start_line: 7 },
      message: "Array 'a[2]' accessed at index 2, which is out of bounds.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "788",
        location_info: "Array index out of bounds",
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "multiple_ignore",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "syntaxError",
      path: "syntaxError.c",
      location: { start_line: 2 },
      message: "Unmatched '{'. Configuration: ''.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: nil,
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "enable",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "readWriteOnlyFile",
      path: "bad.c",
      location: { start_line: 5 },
      message: "Read operation on a file that was opened only for writing.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "664",
        location_info: nil,
      },
    },
    {
      id: "seekOnAppendedFile",
      path: "bad.c",
      location: { start_line: 4 },
      message: "Repositioning operation performed on a file opened in append mode has no effect.",
      links: [],
      object: {
        severity: "warning",
        verbose: nil,
        inconclusive: false,
        cwe: "398",
        location_info: nil,
      },
    },
    {
      id: "unusedFunction",
      path: "bad.c",
      location: { start_line: 1 },
      message: "The function 'foo' is never used.",
      links: [],
      object: {
        severity: "style",
        verbose: nil,
        inconclusive: false,
        cwe: "561",
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "std",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "allocaCalled",
      path: "bad.c",
      location: { start_line: 2 },
      message: "Obsolete function 'alloca' called. In C99 and later it is recommended to use a variable length array instead.",
      links: [],
      object: {
        severity: "warning",
        verbose: /The obsolete function 'alloca' is called./,
        inconclusive: false,
        cwe: nil,
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "project",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "zerodiv",
      path: "main.c",
      location: { start_line: 5 },
      message: "Division by zero.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "369",
        location_info: "Division by zero",
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "language",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "arrayIndexOutOfBounds",
      path: "bad.c",
      location: { start_line: 4 },
      message: "Array 'a[1]' accessed at index 1, which is out of bounds.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: "788",
        location_info: "Array index out of bounds",
      },
    },
    {
      id: "syntaxError",
      path: "bad.cpp",
      location: { start_line: 4 },
      message: "Code 'std::vector' is invalid C code. Use --std or --language to configure the language.",
      links: [],
      object: {
        severity: "error",
        verbose: nil,
        inconclusive: false,
        cwe: nil,
        location_info: nil,
      },
    },
  ],
  analyzer: {
    name: "Cppcheck",
    version: "1.89",
  },
)

Smoke.add_test(
  "unexpected_error",
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "cppcheck: Unknown language 'foo' enforced.",
  analyzer: { name: "Cppcheck", version: :_ },
)
