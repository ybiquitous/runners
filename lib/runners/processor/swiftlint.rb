module Runners
  class Processor::Swiftlint < Processor
    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.base.update_fields { |fields|
        fields.merge!({
                        ignore_warnings: boolean?,
                        path: string?,
                        config: string?,
                        lenient: boolean?,
                        'enable-all-rules': boolean?,
                        options: object?(
                          path: string?,
                          config: string?,
                          lenient: boolean?,
                          'enable-all-rules': boolean?
                        )
                      })
      }
    end

    def self.ci_config_section_name
      'swiftlint'
    end

    def analyzer_version
      @analyzer_version ||= extract_version! analyzer_bin, 'version'
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: 'swiftlint', version: analyzer_version)
    end

    def analyze(_changes)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        check_runner_config(config) do |ignore_warnings, options|
          run_analyzer(ignore_warnings, options)
        end
      end
    end

    def check_runner_config(config)
      # Sider option.
      ignore_warnings = ignore_warnings(config)

      # Command line options.
      path = path(config)
      swiftlint_config = swiftlint_config(config)
      lenient = lenient(config)
      enable_all_rules = enable_all_rules(config)

      options = [path, swiftlint_config, lenient, enable_all_rules].compact.flatten
      yield ignore_warnings, options
    end

    def ignore_warnings(config)
      config[:ignore_warnings] || false
    end

    def path(config)
      path = config[:path] || config.dig(:options, :path)
      ["--path", "#{path}"] if path
    end

    def swiftlint_config(config)
      config = config[:config] || config.dig(:options, :config)
      ["--config", "#{config}"] if config
    end

    def lenient(config)
      lenient = config[:lenient] || config.dig(:options, :lenient)
      "--lenient" if lenient
    end

    def enable_all_rules(config)
      enable_all_rules = config[:'enable-all-rules'] || config.dig(:options, :'enable-all-rules')
      "--enable-all-rules" if enable_all_rules
    end

    def parse_result(stdout, ignore_warnings)
      JSON.parse(stdout).map do |error|
        start_line = error['line']
        message = error['reason']
        id = error['rule_id']
        fname = error['file']

        next if ignore_warnings && error['severity'] == 'Warning'

        loc = Location.new(
          start_line: start_line,
          start_column: nil,
          end_line: nil,
          end_column: nil
        )
        Issues::Text.new(
          path: relative_path(fname),
          location: loc,
          id: id,
          message: message,
          links: []
        )
      end.compact
    end

    def run_analyzer(ignore_warnings, options)
      stdout, stderr, status = capture3(
        analyzer_bin,
        'lint',
        '--reporter', 'json',
        *options,
      )

      # https://github.com/realm/SwiftLint/pull/584
      # 0: No errors, maybe warnings in non-strict mode
      # 1: Usage or system error
      # 2: Style violations of severity "Error"
      # 3: No style violations of severity "Error", but violations of severity "warning" with --strict
      #
      # Otherwise it may be aborted.
      exitstatus = status.exitstatus
      unless [0, 2, 3].include?(exitstatus)
        summary = if exitstatus
                    "SwiftLint exited with unexpected status #{exitstatus}."
                  else
                    "SwiftLint aborted."
                  end
        return Results::Failure.new(guid: guid, message: <<~TEXT, analyzer: analyzer)
          #{summary}
          STDOUT:
          #{stdout}
          STDERR:
          #{stderr}
        TEXT
      end

      # See: https://github.com/realm/SwiftLint/pull/2491
      #
      # SwiftLint has exited with status 2 when setting wrong `swiftlint_version` in `.swiftlint.yml`.
      # Since empty string is returned as stdout, this condition catches the return value to prevent `JSON::ParseError`.
      if exitstatus == 2 && stdout.empty?
        message = <<~MESSAGE
          This analysis was failure since SwiftLint exited with status #{exitstatus} and its stdout was empty.
          STDERR:
          #{stderr}
        MESSAGE
        trace_writer.message message
        return Results::Failure.new(guid: guid, message: message, analyzer: analyzer)
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        parse_result(stdout, ignore_warnings).each { |v| result.add_issue(v) }
      end
    end
  end
end
