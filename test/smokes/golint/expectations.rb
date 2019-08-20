NodeHarness::Testing::Smoke.add_test("success", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "main.go",
      location: { :start_line => 6 },
      id: "edf57ab64b4d061a5cefa2b2ee80ea5de31c58d2",
      message: "don't use underscores in Go names; var awesome_text should be awesomeText",
      links: []
    }
  ],
  analyzer: {
    name: "golint",
    version: "gometalinter version 3.0.0 built from df395bfa67c5d0630d936c0044cf07ff05086655 on 2019-01-29T22:44:16Z"
  }
})
