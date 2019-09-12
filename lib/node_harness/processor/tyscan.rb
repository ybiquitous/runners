module NodeHarness
  class Processor::Tyscan < Processor
    # Define schema in sider.yml
    Schema = StrongJSON.new do
      let :runner_config, Schema::RunnerConfig.npm.update_fields { |fields|
        fields.merge!({
                        config: string?,
                        tsconfig: string?,
                        paths: array?(string),
                      })
      }

      let :issue_object, object(
        id: string,
        message: string,
      )
    end

    DEFAULT_CONFIG_NOT_FOUND_ERROR = <<~MESSAGE.freeze
      `tyscan.yml` does not exist in your repository.

      To start performing analysis, `tyscan.yml` is required.
      See also: https://help.sider.review/tools/javascript/tyscan
    MESSAGE

    def self.ci_config_section_name
      'tyscan'
    end

    def tyscan_bin
      @tyscan_bin ||= if (current_dir + 'node_modules/.bin/tyscan').exist? && (current_dir + 'node_modules/.bin/tsc').exist?
                        'node_modules/.bin/tyscan'
                      else
                        'tyscan'
                      end
    end

    def analyzer_version
      @analyzer_version ||= capture3(tyscan_bin, '--version').first.strip
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: "TyScan", version: analyzer_version)
    end

    def setup
      ensure_runner_config_schema(Schema.runner_config) do |config|
        if !(current_dir + 'tyscan.yml').exist? && config[:config].nil?
          trace_writer.error DEFAULT_CONFIG_NOT_FOUND_ERROR
          add_warning DEFAULT_CONFIG_NOT_FOUND_ERROR
          return Results::Success.new(guid: guid, analyzer: analyzer)
        end

        install_dependencies(config)
        yield
      end
    end

    def analyze(_)
      ensure_runner_config_schema(Schema.runner_config) do |config|
        tyscan_test(config)
        tyscan_scan(config)
      end
    end

    def install_dependencies(config)
      return unless (current_dir + 'package.json').exist?

      case config[:npm_install]
      when false
        # noop
      when 'production'
        capture3_with_retry!('npm', 'install', '--only=production', '--ignore-scripts')
      when 'development'
        capture3_with_retry!('npm', 'install', '--only=development', '--ignore-scripts')
      else
        capture3_with_retry!('npm', 'install', '--ignore-scripts')
      end
    end

    def tyscan_test(config)
      args = []
      args.unshift("-t", config[:tsconfig]) if config[:tsconfig]
      args.unshift("-c", config[:config]) if config[:config]

      _, _, status = capture3(tyscan_bin, "test", *args)

      if status.nil? || !status.success?
        msg = <<~MESSAGE.chomp
          `tyscan test` failed. It may cause an unintended match.
        MESSAGE
        add_warning(msg, file: config[:config] || "tyscan.yml")
      end
    end

    def tyscan_scan(config)
      args = []
      args.unshift(*config[:paths]) if config[:paths]
      args.unshift("-t", config[:tsconfig]) if config[:tsconfig]
      args.unshift("-c", config[:config]) if config[:config]

      stdout, stderr, status = capture3(tyscan_bin, "scan", "--json", *args)

      # TyScan exited with 0 when finishing an analysis correctly.
      unless status.exitstatus == 0
        return Results::Failure.new(guid: guid, message: <<~MESSAGE, analyzer: analyzer)
          TyScan was failed with status #{status.exitstatus} since an unexpected error occurred.

          STDERR:
          #{stderr}
        MESSAGE
      end

      json = JSON.parse(stdout, symbolize_names: true)

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json[:matches].each do |match|
          result.add_issue Issues::Structured.new(
            id: match[:rule][:id],
            path: relative_path(match[:path]),
            location: Location.new(
              start_line: match[:location][:start][0],
              start_column: match[:location][:start][1],
              end_line: match[:location][:end][0],
              end_column: match[:location][:end][1],
            ),
            object: {
              id: match[:rule][:id],
              message: match[:rule][:message],
            },
            schema: Schema.issue_object,
          )
        end
      end
    end
  end
end
