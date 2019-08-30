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

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer!).tap do |result|
            parse_result(stderr) do |issue|
              result.add_issue issue
            end
          end
        end

        def parse_result(output)
          doc = Nokogiri::XML(output)

          doc.errors.map(&:message).join("\n").tap do |msg|
            trace_writer.error msg if msg
          end

          doc.css("errors > error").each do |err|
            err.css("location").each do |loc|
              yield NodeHarness::Issues::Text.new(
                id: err[:id],
                message: "#{err[:msg]} (#{err[:severity]})",
                path: relative_path(loc[:file]),
                location: NodeHarness::Location.new(start_line: loc[:line]),
                links: [],
              )
            end
          end
        end
      end
    end
  end
end
