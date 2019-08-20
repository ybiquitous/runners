NodeHarness::Testing::Smoke.add_test("success", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [{
                 id: "no-console",
                 path: "range.ts",
                 location: { :start_line => 11, :end_line => 11 },
                 message: "Calls to 'console.log' are not allowed. (no-console)",
                 links: [],
             },{
                 id: "no-shadowed-variable",
                 path: "range.ts",
                 location: { :start_line => 1, :end_line => 1 },
                 message: "Shadowed name: 'range' (no-shadowed-variable)",
                 links: [],
             },{
                 id: "object-literal-sort-keys",
                 path: "range.ts",
                 location: { :start_line => 7, :end_line => 7 },
                 message: "The key 'middle' is not sorted alphabetically (object-literal-sort-keys)",
                 links: [],
             },{
                 id: "space-before-function-paren",
                 path: "range.ts",
                 location: { :start_line => 1, :end_line => 1 },
                 message: "Spaces before function parens are disallowed (space-before-function-paren)",
                 links: [],
             },{
                 id: "trailing-comma",
                 path: "range.ts",
                 location: { :start_line => 8, :end_line => 8 },
                 message: "Missing trailing comma (trailing-comma)",
                 links: [],
             }],
    analyzer: { name: "TSLint", version: "5.18.0" }
})

NodeHarness::Testing::Smoke.add_test("with-tslint-json", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [{
                 id: "trailing-comma",
                 path: "range.ts",
                 location: { :start_line => 8, :end_line => 8 },
                 message: "Missing trailing comma (trailing-comma)",
                 links: [],
             }],
    analyzer: { name: "TSLint", version: "5.18.0" }
})

NodeHarness::Testing::Smoke.add_test("npm-install", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [{
                 id: "interface-name",
                 path: "hello.tsx",
                 location: { :start_line => 3, :end_line => 3 },
                 message: "interface name must start with a capitalized I (interface-name)",
                 links: [],
             },{
                 id: "jsx-self-close",
                 path: "hello.tsx",
                 location: { :start_line => 12, :end_line => 12 },
                 message: "JSX elements with no children must be self-closing (jsx-self-close)",
                 links: [],
             },{
                 id: "member-access",
                 path: "hello.tsx",
                 location: { :start_line => 8, :end_line => 8 },
                 message: "The class method 'render' must be marked either 'private', 'public', or 'protected' (member-access)",
                 links: [],
             }],
    analyzer: { name: "TSLint", version: "5.2.0" }
})

NodeHarness::Testing::Smoke.add_test("custom-rules", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [{
                 id: "no-cats",
                 path: "cat.ts",
                 location: { :start_line => 11, :end_line => 16 },
                 message: "Meow! (no-cats)",
                 links: [],
             }],
    analyzer: { name: "TSLint", version: "5.4.3" }
})

NodeHarness::Testing::Smoke.add_test("tsconfig", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [{
                 id: "no-console",
                 path: "range.ts",
                 location: { start_line: 11, end_line: 11 },
                 message: "Calls to 'console.log' are not allowed. (no-console)",
                 links: [],
              },{
                 id: "no-shadowed-variable",
                 path: "range.ts",
                 location: { start_line: 1, end_line: 1 },
                 message: "Shadowed name: 'range' (no-shadowed-variable)",
                 links: [],
              },{
                 id: "object-literal-sort-keys",
                 path: "range.ts",
                 location: { start_line: 7, end_line: 7 },
                 message: "The key 'middle' is not sorted alphabetically (object-literal-sort-keys)",
                 links: [],
              },{
                 id: "space-before-function-paren",
                 path: "range.ts",
                 location: { start_line: 1, end_line: 1 },
                 message: "Spaces before function parens are disallowed (space-before-function-paren)",
                 links: [],
              },{
                 id: "trailing-comma",
                 path: "range.ts",
                 location: { start_line: 8, end_line: 8 },
                 message: "Missing trailing comma (trailing-comma)",
                 links: [],
              }],
    analyzer: { name: "TSLint", version: "5.18.0" }
})

NodeHarness::Testing::Smoke.add_test("raise-deprecated", {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    message: <<~MESSAGE,
      --type-check is deprecated. You only need --project to enable rules which need type information.
      Error at range.ts:2:18: Property 'min' does not exist on type 'string'.
      Error at range.ts:2:31: Property 'middle' does not exist on type 'string'.
      Error at range.ts:2:47: Property 'middle' does not exist on type 'string'.
      Error at range.ts:2:63: Property 'max' does not exist on type 'string'.
      Error at range.ts:11:24: Argument of type '{ min: number; middle: number; max: number; }' is not assignable to parameter of type 'string'.
      MESSAGE
    analyzer: { name: "TSLint", version: "5.18.0" }
})

NodeHarness::Testing::Smoke.add_test("deprecated-rules", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [{
             id: "no-unused-variable",
             path: "index.ts",
             location: { :start_line => 2, :end_line => 2 },
             message: "'a' is declared but its value is never read. (no-unused-variable)",
             links: [],
           },{
             id: "no-unused-variable",
             path: "index.ts",
             location: { :start_line => 2, :end_line => 2 },
             message: "'b' is declared but its value is never read. (no-unused-variable)",
             links: [],
           },{
             id: "no-unused-variable",
             path: "index.ts",
             location: { :start_line => 5, :end_line => 5 },
             message: "All destructured elements are unused. (no-unused-variable)",
             links: [],
           }],
  analyzer: { name: "TSLint", version: "5.11.0" }
})

NodeHarness::Testing::Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Invalid configuration in sideci.yml: unexpected value at config: $.linter.tslint.config",
  analyzer: nil
})

NodeHarness::Testing::Smoke.add_test("with_options", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      message: "Type declaration of 'any' loses type-safety. Consider replacing it with a more precise type. (no-any)",
      links: [],
      id: "no-any",
      path: "src/range.ts",
      location: { start_line: 1,  end_line: 1 }
    }
  ],
  analyzer: { name: "TSLint", version: "5.15.0" }
})

NodeHarness::Testing::Smoke.add_test("rules-dir", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      id: "no-cats",
      path: "cat.ts",
      location: { :start_line => 11, :end_line => 16 },
      message: "Meow! (no-cats)",
      links: [],
    }
  ],
  analyzer: { name: "TSLint", version: "5.15.0" }
})

NodeHarness::Testing::Smoke.add_test("multiple-custom-rules", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      message: "Meow! (no-cats)",
      links: [],
      id: "no-cats",
      path: "cat.ts",
      location: { start_line: 11, end_line: 16 }
    },
    {
      message: "Bow! (no-dogs)",
      links: [],
      id: "no-dogs",
      path: "dog.ts",
      location: { start_line: 11, end_line: 16 }
    }
  ],
  analyzer: { name: "TSLint", version: "5.15.0" }
})

NodeHarness::Testing::Smoke.add_test("invalid-tslint-version", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: /Your 'tslint' settings couldn't satisfy the required constraints/,
  analyzer: nil,
})

NodeHarness::Testing::Smoke.add_test("without-tslint-in-package-json", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "TSLint", version: "5.18.0" },
}, {
  warnings: [
    { message: /No required dependencies for analysis were installed/, file: "package.json" },
  ],
})

NodeHarness::Testing::Smoke.add_test("without-tslint-and-with-typescript-in-package-json", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [],
  analyzer: { name: "TSLint", version: "5.18.0" },
}, {
  warnings: [
    { message: /No required dependencies for analysis were installed/, file: "package.json" },
  ],
})

NodeHarness::Testing::Smoke.add_test("mismatched_package_version", {
  guid: 'test-guid',
  timestamp: :_,
  type: "failure",
  message: "'yarn install' failed. Please confirm 'yarn.lock' is consistent with 'package.json'.",
  analyzer: nil
})
