module NodeHarness
  module Runners
    module Cppcheck
      class Processor < NodeHarness::Processor
        Schema = _ = StrongJSON.new do
          # @type self: JSONSchema
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
            fields.merge!(
              target: enum?(string, array(string)),
              ignore: enum?(string, array(string)),
              enable: string?,
              std: string?,
              project: string?,
              language: string?,
            )
          }

          let :rule, object(
            severity: string,
            message: string,
            verbose: string?,
            inconclusive: boolean,
            cwe: string?,
            location_info: string?,
          )
        end

        DEFAULT_TARGET = ".".freeze
        DEFAULT_IGNORE = [].freeze

        def self.ci_config_section_name
          "cppcheck"
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: "Cppcheck", version: analyzer_version)
        end

        def analyzer_version
          @analyzer_version ||= extract_version! cppcheck, pattern: /Cppcheck (\d+\.\d+)/
        end

        def setup
          analyzer!
          yield
        end

        def analyze(_changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            @config = config
            run_analyzer
          end
        end

        private

        def cppcheck
          "cppcheck"
        end

        def config
          @config or raise "Must be initialized!"
        end

        def target
          Array(config[:target] || DEFAULT_TARGET)
        end

        def ignore
          Array(config[:ignore] || DEFAULT_IGNORE).map { |i| ["-i", i] }.flatten
        end

        def enable
          id = config[:enable]
          Array(id ? "--enable=#{id}" : nil)
        end

        def std
          id = config[:std]
          Array(id ? "--std=#{id}" : nil)
        end

        def project
          file = config[:project]
          Array(file ? "--project=#{file}" : nil)
        end

        def language
          lang = config[:language]
          Array(lang ? "--language=#{lang}" : nil)
        end

        def run_analyzer
          _stdout, stderr = capture3!(
            cppcheck,
            "--quiet",
            "--xml",
            *ignore,
            *enable,
            *std,
            *project,
            *language,
            *target,
          )

          xml_output = Nokogiri::XML::Document.parse(stderr)

          unless xml_output.errors.empty?
            xml_syntax_errors = xml_output.errors.map(&:message).join("\n")
            return NodeHarness::Results::Failure.new(guid: guid, analyzer: analyzer!, message: xml_syntax_errors)
          end

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            parse_result(xml_output) do |issue|
              result.add_issue issue
            end
          end
        end

        # @see https://github.com/danmar/cppcheck/blob/master/man/manual.md#xml-output
        def parse_result(xml_doc)
          xml_doc.css("errors > error").each do |err|
            err.css("location").each do |loc|
              yield NodeHarness::Issues::Structured.new(
                id: err[:id],
                path: relative_path(loc[:file]),
                location: NodeHarness::Location.new(start_line: loc[:line]),
                object: {
                  severity: err[:severity],
                  message: err[:msg],
                  verbose: err[:verbose] != err[:msg] ? err[:verbose] : nil,
                  inconclusive: err[:inconclusive] == "true",
                  cwe: err[:cwe],
                  location_info: loc[:info] != err[:msg] ? loc[:info] : nil,
                },
                schema: Schema.rule,
              )
            end
          end
        end
      end
    end
  end
end
