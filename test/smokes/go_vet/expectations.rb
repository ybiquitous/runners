s = Runners::Testing::Smoke

s.add_test(
  "success",
  type: "success",
  issues: [
    {
      path: "main.go",
      location: { start_line: 7 },
      id: "bc596b8e1c54fbda9055c3f53940b5df39d6c11f",
      message: "Printf call has arguments but no formatting directives",
      links: [],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "go vet", version: "3.0.0" },
  warnings: [
    {
      message: <<~MSG.strip,
DEPRECATION WARNING!!!
The support for go vet is deprecated. Sider will drop these versions on April 30, 2020.
Please consider using an alternative tool GolangCI-Lint. See https://help.sider.review/tools/go/govet
MSG
      file: "sider.yml"
    }
  ]
)
