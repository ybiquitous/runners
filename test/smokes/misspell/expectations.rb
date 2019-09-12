NodeHarness::Testing::Smoke.add_test("success", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: '"infomation" is a misspelling of "information"',
        links: [],
        id: '"infomation" is a misspelling of "information"',
        path: 'badspell.rb',
        location: {start_line: 2, start_column: 2, end_line: 2, end_column: 12}
      }
    ],
    analyzer: {
      name: 'Misspell',
      version: '0.3.4'
    }
})

NodeHarness::Testing::Smoke.add_test("locale", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: '"infomation" is a misspelling of "information"',
        links: [],
        id: '"infomation" is a misspelling of "information"',
        path: 'badspell.rb',
        location: {start_line: 4, start_column: 2, end_line: 4, end_column: 12}
      },
      {
        message: '"offense" is a misspelling of "offence"',
        links: [],
        id: '"offense" is a misspelling of "offence"',
        path: 'badspell.rb',
        location: {start_line: 3, start_column: 2, end_line: 3, end_column: 9}
      }
    ],
    analyzer: {
      name: 'Misspell',
      version: '0.3.4'
    }
})

NodeHarness::Testing::Smoke.add_test("ignore", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      {
        message: '"recieve" is a misspelling of "receive"',
        links: [],
        id: '"recieve" is a misspelling of "receive"',
        path: 'badspell.rb',
        location: {start_line: 3, start_column: 2, end_line: 3, end_column: 9}
      }
    ],
    analyzer: {
      name: 'Misspell',
      version: '0.3.4'
    }
})

NodeHarness::Testing::Smoke.add_test('analyze_specific_targets', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      links: [],
      id: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      path: "target_dir/bar.rb",
      location:  { start_line: 2, start_column: 2, end_line: 2, end_column: 13 } },
    { message: "\"comminucation\" is a misspelling of \"communications\"",
      links: [],
      id: "\"comminucation\" is a misspelling of \"communications\"",
      path: "target_dir/foo.rb",
      location:  { start_line: 3, start_column: 2, end_line: 3, end_column: 15 } },
    { message: "\"comminucation\" is a misspelling of \"communications\"",
      links: [],
      id: "\"comminucation\" is a misspelling of \"communications\"",
      path: "target_file.rb",
      location:  { start_line: 3, start_column: 2, end_line: 3, end_column: 15 } },
    { message: "\"infomation\" is a misspelling of \"information\"",
      links: [],
      id: "\"infomation\" is a misspelling of \"information\"",
      path: "target_dir/bar.rb",
      location:  { start_line: 3, start_column: 2, end_line: 3, end_column: 12 } },
    { message: "\"recieve\" is a misspelling of \"receive\"",
      links: [],
      id: "\"recieve\" is a misspelling of \"receive\"",
      path: "target_dir/foo.rb",
      location:  { start_line: 2, start_column: 2, end_line: 2, end_column: 9 } },
    { message: "\"recieve\" is a misspelling of \"receive\"",
      links: [],
      id: "\"recieve\" is a misspelling of \"receive\"",
      path: "target_file.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 9 } }
  ],
  analyzer: {
    name: 'Misspell',
    version: '0.3.4'
  }
})

NodeHarness::Testing::Smoke.add_test('exclude_targets', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'success',
  issues: [
    { message: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      links: [],
      id: "\"acknowleges\" is a misspelling of \"acknowledges\"",
      path: "target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 13 } },
    { message: "\"communiaction\" is a misspelling of \"communications\"",
      links: [],
      id: "\"communiaction\" is a misspelling of \"communications\"",
      path: "partial_exclude_dir/target.html",
      location: { start_line: 1, start_column: 5, end_line: 1, end_column: 18 } },
    { message: "\"internelized\" is a misspelling of \"internalized\"",
      links: [],
      id: "\"internelized\" is a misspelling of \"internalized\"",
      path: "partial_exclude_dir/bar_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 } },
    { message: "\"optimizacion\" is a misspelling of \"optimization\"",
      links: [],
      id: "\"optimizacion\" is a misspelling of \"optimization\"",
      path: "partial_exclude_dir/bar_dir/target.js",
      location: { start_line: 1, start_column: 9, end_line: 1, end_column: 21 } },
    { message: "\"profissional\" is a misspelling of \"professional\"",
      links: [],
      id: "\"profissional\" is a misspelling of \"professional\"",
      path: "foo_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 } },
    { message: "\"requeriments\" is a misspelling of \"requirements\"",
      links: [],
      id: "\"requeriments\" is a misspelling of \"requirements\"",
      path: "foo_dir/another_dir/target.html",
      location: { start_line: 1, start_column: 4, end_line: 1, end_column: 16 } },
    { message: "\"scholarhsips\" is a misspelling of \"scholarships\"",
      links: [],
      id: "\"scholarhsips\" is a misspelling of \"scholarships\"",
      path: "foo_dir/another_dir/target.rb",
      location: { start_line: 2, start_column: 2, end_line: 2, end_column: 14 } },
    { message: "\"trasnmission\" is a misspelling of \"transmissions\"",
      links: [],
      id: "\"trasnmission\" is a misspelling of \"transmissions\"",
      path: "partial_exclude_dir/foo_dir/target.py",
      location: { start_line: 2, start_column: 4, end_line: 2, end_column: 16 } }
  ],
  analyzer: {
    name: 'Misspell',
    version: '0.3.4'
  }
})

NodeHarness::Testing::Smoke.add_test('broken_sideci_yml', {
  guid: 'test-guid',
  timestamp: :_,
  type: 'failure',
  message: "Invalid configuration in `sideci.yml`: unexpected value at config: `$.linter.misspell.locale`",
  analyzer: nil
})
