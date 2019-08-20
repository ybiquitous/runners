NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: { name: 'pmd_java', version: "6.17.0" },   # This is only one place testing the version number. Cannot be deleted!
  issues: [
    { message: "System.out.println is used",
      links: ["https://pmd.github.io/pmd/pmd_rules_java_bestpractices.html#systemprintln"],
      id: "Best Practices-SystemPrintln-df6e8cab6195f150091bd209ddf59cb021c1253f",
      path: "src/Hello.java",
      location: { start_line: 6, start_column: 9, end_line: 6, end_column: 26 } }
  ],
}, warnings: [
  { message: :_, file: "src/Broken.java" }   # The error message is like "Error while parsing /tmp/d20171130-1-1px25r0/src/Broken.java", which contains tmpdir path, so that it cannot be tested here
])

# `java-optimizations` has become an old ruleset style since 6.0.0. However this style still kept for backwards-compatibility.
NodeHarness::Testing::Smoke.add_test("old-rulesets-style", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: { name: 'pmd_java', version: :_ },
  issues: [
    { message: "Parameter 'args' is not assigned and could be declared final",
      links: ["https://pmd.github.io/pmd/pmd_rules_java_codestyle.html#methodargumentcouldbefinal"],
      id: "Code Style-MethodArgumentCouldBeFinal-f7008600fe4fd7c0e84e4910bcd4a4b7b8c41b67",
      path: "Main.java",
      location: { start_line: 5, start_column: 29, end_line: 5, end_column: 41 } }
  ]
}, warnings: [
  { message: "Use Rule name category/java/codestyle.xml/LocalVariableCouldBeFinal instead of the deprecated Rule name rulesets/java/optimizations.xml/LocalVariableCouldBeFinal. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/codestyle.xml/MethodArgumentCouldBeFinal instead of the deprecated Rule name rulesets/java/optimizations.xml/MethodArgumentCouldBeFinal. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/codestyle.xml/PrematureDeclaration instead of the deprecated Rule name rulesets/java/optimizations.xml/PrematureDeclaration. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/AddEmptyString instead of the deprecated Rule name rulesets/java/optimizations.xml/AddEmptyString. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/AvoidArrayLoops instead of the deprecated Rule name rulesets/java/optimizations.xml/AvoidArrayLoops. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/AvoidInstantiatingObjectsInLoops instead of the deprecated Rule name rulesets/java/optimizations.xml/AvoidInstantiatingObjectsInLoops. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/RedundantFieldInitializer instead of the deprecated Rule name rulesets/java/optimizations.xml/RedundantFieldInitializer. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/SimplifyStartsWith instead of the deprecated Rule name rulesets/java/optimizations.xml/SimplifyStartsWith. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/UnnecessaryWrapperObjectCreation instead of the deprecated Rule name rulesets/java/optimizations.xml/UnnecessaryWrapperObjectCreation. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/UseArrayListInsteadOfVector instead of the deprecated Rule name rulesets/java/optimizations.xml/UseArrayListInsteadOfVector. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/UseArraysAsList instead of the deprecated Rule name rulesets/java/optimizations.xml/UseArraysAsList. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil },
  { message: "Use Rule name category/java/performance.xml/UseStringBufferForStringAppends instead of the deprecated Rule name rulesets/java/optimizations.xml/UseStringBufferForStringAppends. PMD 7.0.0 will remove support for this deprecated Rule name usage.", file: nil }
])

NodeHarness::Testing::Smoke.add_test("config", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: { name: 'pmd_java', version: :_ },
  issues: [
    { message: "Parameter 'args' is not assigned and could be declared final",
      links: ["https://pmd.github.io/pmd/pmd_rules_java_codestyle.html#methodargumentcouldbefinal"],
      id: "Code Style-MethodArgumentCouldBeFinal-f7008600fe4fd7c0e84e4910bcd4a4b7b8c41b67",
      path: "src/Main.java",
      location: { start_line: 5, start_column: 29, end_line: 5, end_column: 41 } },
    { message: "Avoid short class names like Main",
      links: ["https://pmd.github.io/pmd/pmd_rules_java_codestyle.html#shortclassname"],
      id: "Code Style-ShortClassName-06b374edd6bbc3bb8ea848f704304de5f14ca11a",
      path: "src/Main.java",
      location: { start_line: 3, start_column: 8, end_line: 8, end_column: 1 } }
  ]
})

NodeHarness::Testing::Smoke.add_test("duplicate-rule-name", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: { name: 'pmd_java', version: :_ },
  issues: [
    { message: "Comment is too large: Too many lines",
      links: ["https://pmd.github.io/pmd/pmd_rules_java_documentation.html#commentsize"],
      id: "Documentation-CommentSize-10c545bd6ffe0bb7c6551a1191762accb45679b9",
      path: "Main.java",
      location: { start_line: 10, start_column: 1, end_line: 34, end_column: 2 } },
    { message: "Comment is too large: Line too long",
      links: ["https://pmd.github.io/pmd/pmd_rules_java_documentation.html#commentsize"],
      id: "Documentation-CommentSize-ae3f424f4ea74990ded4b6dc9ae2cdc55048b9a6",
      path: "Main.java",
      location: { start_line: 10, start_column: 1, end_line: 10, end_column: 2} },
  ]
})

NodeHarness::Testing::Smoke.add_test("failure", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  analyzer: { name: 'pmd_java', version: :_ },
  message: :_
})

NodeHarness::Testing::Smoke.add_test("deprecated-functions", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: { name: 'pmd_java', version: :_ },
  issues: [
    { message: "violation message",
      links: [],
      id: "Custom Rules-typeof is deprecated-c887b4750ce655634fbf91df220ddffaddd09df0",
      path: "Foo.java",
      location: { start_line: 3, start_column: 8, end_line: 3, end_column: 37 } },
  ]
}, warnings: [
  { message: "The XPath function typeof() is deprecated and will be removed in 7.0.0. Use typeIs() instead.", file: nil },
])

NodeHarness::Testing::Smoke.add_test("broken_sideci_yml", {
  guid: "test-guid",
  timestamp: :_,
  type: "failure",
  analyzer: nil,
  message: "Invalid configuration in sideci.yml: unexpected value at config: $.linter.pmd_java.min_priority"
})

NodeHarness::Testing::Smoke.add_test("deprecated-rules", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  analyzer: { name: 'pmd_java', version: :_ },
  issues: [
    {
      message: "The String literal \"Howdy\" appears 4 times in this file; the first occurrence is on line 3",
     links: ["https://pmd.github.io/pmd/pmd_rules_java_errorprone.html#avoidduplicateliterals"],
     id: "Error Prone-AvoidDuplicateLiterals-28a11656e010dd99ee7ca2fa590407e3007bee18",
     path: "AvoidDupliatedLiterals.java",
     location: { start_line: 3, start_column: 13, end_line: 3, end_column: 19 }
    }
  ]
}, warnings: [{
    message: "Rule AvoidDuplicateLiterals uses deprecated property 'exceptionFile'. Future versions of PMD will remove support for this property. Please use 'exceptionList' instead.",
    file: nil
  }]
)
