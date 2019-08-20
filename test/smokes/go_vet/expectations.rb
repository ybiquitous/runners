NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "main.go",
      location: { :start_line => 7 },
      id: "bc596b8e1c54fbda9055c3f53940b5df39d6c11f",
      message: "Printf call has arguments but no formatting directives",
      links: []
    }
  ],
  analyzer: {
    name: "go_vet",
    version: "gometalinter version 3.0.0 built from df395bfa67c5d0630d936c0044cf07ff05086655 on 2019-01-29T22:44:16Z"
  }
})
