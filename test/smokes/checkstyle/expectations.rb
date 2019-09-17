Smoke = Runners::Testing::Smoke

Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'checkstyle', version: '8.23'},
  issues: [
    {
      message: "The name of the outer type and the file do not match.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.OuterTypeFilenameCheck#b81ef5",
      path: "src/Hello.java",
      location: { start_line: 3 }
    },
    {
      message: "'method def' child has incorrect indentation level 8, expected level should be 4.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck#2aa7da",
      path: "src/Hello.java",
      location: { start_line: 6 }
    },
    {
      message: "'method def modifier' has incorrect indentation level 4, expected level should be 2.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck#d0bdde",
      path: "src/Hello.java",
      location: { start_line: 5 }
    },
    {
      message: "'method def rcurly' has incorrect indentation level 4, expected level should be 2.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.indentation.IndentationCheck#e7930a",
      path: "src/Hello.java",
      location: { start_line: 7 }
    }
  ],
})

Smoke.add_test("config", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: {name: 'checkstyle', version: '8.23'},
  issues: [
    {
      message: "Parameter args should be final.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.FinalParametersCheck#0bbcea",
      path: "src/Main.java",
      location: { start_line: 5 }
    },
    {
      message: "Utility classes should not have a public or default constructor.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.design.HideUtilityClassConstructorCheck#97f5fb",
      path: "src/Main.java",
      location: { start_line: 3 }
    },
    {
      message: "Missing package-info.java file.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.javadoc.JavadocPackageCheck#1cbcec",
      path: "src/Main.java",
      location: { start_line: 1 }
    },
    {
      message: "Missing a Javadoc comment.",
      links: [],
      id: "com.puppycrawl.tools.checkstyle.checks.javadoc.MissingJavadocMethodCheck#0cbebf",
      path: "src/Main.java",
      location: { start_line: 5 }
    }
  ]
})

Smoke.add_test("failure", {
  guid: "test-guid",
  timestamp: :_,
  type: "error",
  class: :_,
  backtrace: :_,
  inspect: :_
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
      location: { start_line: 3 }
    }
  ],
  analyzer: {name: 'checkstyle', version: '8.23'}
})
