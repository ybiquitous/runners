Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "success",
  {
    guid: "test-guid",
    timestamp: :_,
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
    analyzer: { name: "go_vet", version: "3.0.0" }
  }
)
