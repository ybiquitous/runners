# Smoke test allows testing by input and output of the analysis.
# Following example, create "success" directory and put files, configurations, etc in this directory.
#
# NodeHarness::Testing::Smoke.add_test("success", {
#     guid: "test-guid",
#     timestamp: :_,
#     type: "success",
#     issues: [
#         { path: "foo.rb",
#           location: { :start_line => 1, :start_column => 7, :end_line => 1, :end_column => 34 },
#           id: "com.test.pathname",
#           object: { :id => "com.test.pathname",
#                     :messages => ["Use Pathname method instead"],
#                     :justifications => [] } }
#     ],
#     analyzer: {
#       name: 'ToolName',
#       version: '0.0.0'
#     }
# })
