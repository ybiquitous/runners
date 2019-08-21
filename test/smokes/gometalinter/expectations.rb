NodeHarness::Testing::Smoke.add_test("success", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
})

NodeHarness::Testing::Smoke.add_test("require_install", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
      { path: "main.go",
        location: {start_line: 12},
        id: "bc596b8e1c54fbda9055c3f53940b5df39d6c11f",
        message: "[vet] Printf call has arguments but no formatting directives",
        links: []
      }
    ],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
})

NodeHarness::Testing::Smoke.add_test("private_dependency", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
        { path: "main.go",
          location: {start_line: 13},
          id: "bc596b8e1c54fbda9055c3f53940b5df39d6c11f",
          message: "[vet] Printf call has arguments but no formatting directives",
          links: []
        }
    ],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
}) do |config|
  config.ssh_key = "ssh_key"
end

NodeHarness::Testing::Smoke.add_test("specify_config", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [{:message=>
       "[gotype] could not import os/exec (type-checking package \"os/exec\" failed (/usr/local/go/src/os/exec/exec.go:24:2: could not import bytes (type-checking package \"bytes\" failed (/usr/local/go/src/bytes/buffer.go:11:2: could not import io (type-checking package \"io\" failed (/usr/local/go/src/io/pipe.go:12:2: could not import sync (type-checking package \"sync\" failed (/usr/local/go/src/sync/pool.go:9:2: could not import runtime (type-checking package \"runtime\" failed (/usr/local/go/src/runtime/mem_linux.go:21:6: sysAlloc redeclared in this block))))))))))",
      :links=>[],
      :id=>"152f86d2dcabcd37584e31c6eebc2a55c2f669e7",
      :path=>"main.go",
      :location=>{:start_line=>5}},
     {:message=>
       "[gotype] could not import fmt (type-checking package \"fmt\" failed (/usr/local/go/src/fmt/print.go:9:2: could not import internal/fmtsort (type-checking package \"internal/fmtsort\" failed (/usr/local/go/src/internal/fmtsort/sort.go:12:2: could not import reflect (type-checking package \"reflect\" failed (/usr/local/go/src/reflect/type.go:19:2: could not import runtime (type-checking package \"runtime\" failed (/usr/local/go/src/runtime/mem_linux.go:21:6: sysAlloc redeclared in this block))))))))",
      :links=>[],
      :id=>"1d5de803313b0f5ec40777534705e394ac8dd694",
      :path=>"main.go",
      :location=>{:start_line=>4}},
     {:message=>"[golint] const Id should be ID",
      :links=>[],
      :id=>"36ef88e1b6c2a396d1032b473a93606e91fda03b",
      :path=>"main.go",
      :location=>{:start_line=>9}},
     {:message=>
       "[golint] comment on exported const Id should be of the form \"Id ...\"",
      :links=>[],
      :id=>"5058a11cfd937cc5547f20ededd3629ff875a2ca",
      :path=>"main.go",
      :location=>{:start_line=>8}},
     {:message=>
       "[golint] comment on exported function NoDocFunc should be of the form \"NoDocFunc ...\"",
      :links=>[],
      :id=>"54b8e33e5e4f35fef5654c7280e6e3b24be91de0",
      :path=>"main.go",
      :location=>{:start_line=>19}}],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
})

NodeHarness::Testing::Smoke.add_test("install_path", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
}, warnings: [{
  message: '`install_path` option is deprecated. Use `import_path` instead.',
  file: 'sideci.yml',
}])

NodeHarness::Testing::Smoke.add_test("import_path", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
})

NodeHarness::Testing::Smoke.add_test("import_path_and_install_path", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [],
    analyzer: {
        name: "gometalinter",
        version: "gometalinter version 2.0.11 built from 17a7ffa42374937bfecabfb8d2efbd4db0c26741 on 2018-09-09T06:19:21Z"
    }
})
