module NodeHarness
  module Runners
    module Misspell
      class Processor < NodeHarness::Processor
        Schema = StrongJSON.new do
          let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
            fields.merge!({
                            exclude: array?(string),
                            targets: array?(string),
                            locale: enum?(literal('US'), literal('UK')),
                            ignore: string?,
                            # DO NOT ADD ANY OPTIONS under `options`.
                            options: optional(object(
                                                locale: enum?(literal('US'), literal('UK')),
                                                ignore: string?
                                              ))
                          })
          }
        end

        def self.ci_config_section_name
          'misspell'
        end

        def analyzer
          @analyzer ||= NodeHarness::Analyzer.new(name: 'Misspell', version: misspell_version)
        end

        def misspell_version
          capture3!('misspell', '-v').first.chomp
        end

        def setup
          yield
        end

        def analyze(_changes)
          ensure_runner_config_schema(Schema.runner_config) do |config|
            delete_targets(config)
            check_runner_config(config) do |options, targets|
              run_analyzer(options, targets)
            end
          end
        end

        private

        def check_runner_config(config)
          # Misspell options
          locale = locale(config)
          ignore = ignore(config)

          # Target files for analysis.
          targets = analysis_targets(config)

          yield [locale, ignore].flatten.compact, targets
        end

        def run_analyzer(options, targets)
          # NOTE: Prevent command injection with `'--'`.
          stdout, _stderr, _status = capture3!('misspell', *options, '--', *targets)

          NodeHarness::Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
            stdout.split("\n").each do |line|
              match = line.match(/^(?<file>.+):(?<line>\d+):(?<col>\d+): (?<message>"(?<misspell>.+)" is a misspelling of ".+")$/)
              lineno = match[:line].to_i
              col = match[:col].to_i
              misspell = match[:misspell]
              message = match[:message]

              file = match[:file]
              loc = NodeHarness::Location.new(
                start_line: lineno,
                start_column: col,
                end_line: lineno,
                end_column: col + misspell.size,
              )
              result.add_issue NodeHarness::Issues::Text.new(
                path: relative_path(file),
                location: loc,
                id: message,
                message: message,
                links: [],
              )
            end
          end
        end

        def locale(config)
          locale = config[:locale] || config.dig(:options, :locale)
          ["-locale", "#{locale}"] if locale
        end

        def ignore(config)
          # The option requires comma separeted with string when user would like to set ignore multiple targets.
          ignore = config[:ignore] || config.dig(:options, :ignore)
          ["-i", "#{ignore}"] if ignore
        end

        def analysis_targets(config)
          Array(config[:targets] || '.')
        end

        def delete_targets(config)
          exclude_targets = Array(config[:exclude])
          return if exclude_targets.empty?
          trace_writer.message "Excluding #{exclude_targets.join(', ')} ..." do
            paths = exclude_targets.flat_map { |target| Dir.glob(working_dir + target.to_s) }.uniq
            FileUtils.rm_r(paths, secure: true)
          end
        end
      end
    end
  end
end
