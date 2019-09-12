module NodeHarness
  class Processor::Golint < Processor
    def self.ci_config_section_name
      # Section name in sideci.yml, Generally it is the name of analyzer tool.
      "golint"
    end

    def analyzer
      @analyzer ||= Analyzer.new(name: "golint", version: analyzer_version)
    end

    def analyze(changes)
      # NOTE: go_vet cannot output with JSON format, so we use Gometalinter.
      stdout, _, _ = capture3(
        'gometalinter',
        '--disable-all',
        '--enable=golint',
        '--enable-gc',
        '--json',
        './...',
        '--deadline=1200s'
      )
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        JSON.parse(stdout).each do |issue|
          loc = Location.new(
            start_line: issue['line'],
            start_column: nil,
            end_line: nil,
            end_column: nil
          )

          result.add_issue Issues::Text.new(
            path: relative_path(issue['path']),
            location: loc,
            id: Digest::SHA1.hexdigest(issue['message']),
            message: issue['message'],
            links: [],
          )
        end
      end
    end

    def analyzer_version
      @analyzer_version if @analyzer_version
      stdout, _ = capture3!('gometalinter', '--version')
      @analyzer_version = stdout.strip
    end
  end
end
