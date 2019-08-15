module NodeHarness
  module Schema
    Issue = _ = StrongJSON.new do
      # @type self: Types::Issue

      let :location, enum?(object(start_line: number, start_column: number, end_line: number, end_column: number),
                           object(start_line: number, end_line: number),
                           object(start_line: number))

      let :identified, object(id: string, path: string, location: location)

      let :structured, object(object: any, id: string, path: string, location: location)

      let :text, object(message: string, links: array(string), id: string, path: string, location: location)
    end

    Result = _ = StrongJSON.new do
      # @type self: Types::Result

      let :issue, enum(Issue.text, Issue.structured, Issue.identified)
      let :warning, object(message: string, file: string?)
      let :analyzer, object(name: string, version: string)

      let :success, object(guid: string, timestamp: string, type: literal("success"), issues: array(issue), analyzer: analyzer)
      let :failure, object(guid: string, timestamp: string, type: literal("failure"), message: string, analyzer: optional(analyzer))
      let :missing_file_failure, object(guid: string, timestamp: string, type: literal("missing_files"), files: array(string))
      let :error, object(guid: string, timestamp: string, type: literal("error"), class: string, backtrace: array(string), inspect: string)

      let :envelope, object(result: enum(success, failure, missing_file_failure, error), "harness-version": string, warnings: array(warning), ci_config: any?)
    end
  end
end
