Smoke = Runners::Testing::Smoke

Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'checkstyle', version: '8.25'},
  issues: [
    {
      message: "The name of the outer type and the file do not match.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.OuterTypeFilenameCheck#b81ef5",
      path: "src/Hello.java",
      location: { start_line: 3 },
      object: nil,
    },
    {
      message: "'method def' child has incorrect indentation level 8, expected level should be 4.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck#2aa7da",
      path: "src/Hello.java",
      location: { start_line: 6 },
      object: nil,
    },
    {
      message: "'method def modifier' has incorrect indentation level 4, expected level should be 2.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck#d0bdde",
      path: "src/Hello.java",
      location: { start_line: 5 },
      object: nil,
    },
    {
      message: "'method def rcurly' has incorrect indentation level 4, expected level should be 2.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck#e7930a",
      path: "src/Hello.java",
      location: { start_line: 7 },
      object: nil,
    }
  ],
})

Smoke.add_test("config", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'checkstyle', version: '8.25'},
  issues: [
    {
      message: "Parameter args should be final.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.FinalParametersCheck#0bbcea",
      path: "src/Main.java",
      location: { start_line: 5 },
      object: nil,
    },
    {
      message: "Utility classes should not have a public or default constructor.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.design.HideUtilityClassConstructorCheck#97f5fb",
      path: "src/Main.java",
      location: { start_line: 3 },
      object: nil,
    },
    {
      message: "Missing package-info.java file.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocPackageCheck#1cbcec",
      path: "src/Main.java",
      location: { start_line: 1 },
      object: nil,
    },
    {
      message: "Missing a Javadoc comment.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.javadoc.MissingJavadocMethodCheck#0cbebf",
      path: "src/Main.java",
      location: { start_line: 5 },
      object: nil,
    }
  ]
})

Smoke.add_test("failure", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Could not find config XML file 'custom.xml'.",
  analyzer: { name: "checkstyle", version: "8.25" },
})

Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.checkstyle.exclude`",
  analyzer: nil,
})

Smoke.add_test("properties", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      message: "Line is longer than 50 characters (found 67).",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheck#446163",
      path: "src/Main.java",
      location: { start_line: 3 },
      object: nil,
    },
    {
      message: "Line is longer than 50 characters (found 63).",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheck#6a9962",
      path: "myruleset.xml",
      location: { start_line: 4 },
      object: nil,
    },
    {
      message: "Line is longer than 50 characters (found 54).",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheck#8de3eb",
      path: "myruleset.xml",
      location: { start_line: 8 },
      object: nil,
    },
    {
      message: "Line is longer than 50 characters (found 57).",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.sizes.LineLengthCheck#a134cc",
      path: "myruleset.xml",
      location: { start_line: 3 },
      object: nil,
    },
  ],
  analyzer: {name: 'checkstyle', version: '8.25'}
})

Smoke.add_test("syntax_error", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  message: "com.puppycrawl.tools.checkstyle.api.CheckstyleException: Exception was thrown while processing ./Foo.java",
  analyzer: { name: "checkstyle", version: "8.25" },
})
