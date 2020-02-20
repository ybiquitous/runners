module Runners
  # A processor class for FxCop Analyzers
  # https://docs.microsoft.com/en-us/visualstudio/code-quality/install-fxcop-analyzers
  # This is a beta release. We support only repositories that has .csproj file directly under analysis root directory.
  class Processor::FxCop < Processor

    #parameters
    FXCOP_ANALYZER_VERSION = ENV['FXCOP_VERSION']
    ANALYSIS_LOGFILE_PATH = '/tmp/sider_analysis_out.json'.freeze
    RULE_ID_PATTERN = /CA[0-9]+/.freeze

    def self.ci_config_section_name
      'fxcop'
    end

    def analyzer_name
      'fxcop'
    end

    def analyzer_bin
      'dotnet'
    end

    def analyzer_version
      FXCOP_ANALYZER_VERSION
    end

    def setup
      # restore project (install dependencies)
      cmdline_install_dependency = %w(dotnet restore)
      _, _, status = capture3(*cmdline_install_dependency)
      unless status == 0
        msg = <<~EOS
          Failed to restore .NET Core Project. You have to put project file (.csproj) under the analysis root. Please check project structure and Sider config file (sider.yml).
          Note: We only support a project managed with MSBuild. No support for other build systems. (e.g. Nuke, Cake)
        EOS
        return Results::Failure.new(guid: guid, message: msg, analyzer: analyzer)
      end

      # install FxCop Analyzers from nuget Repository
      cmdline_add_analyzer = ['dotnet', 'add', 'package', 'Microsoft.CodeAnalysis.FxCopAnalyzers', '--version', FXCOP_ANALYZER_VERSION]
      capture3!(*cmdline_add_analyzer)

      yield
    end

    def analyze(changes)
      # run 'dotnet build' with static analysis module
      cmdline_run_analyzer = ['dotnet', 'build', '--no-incremental', "-property:errorlog=#{ANALYSIS_LOGFILE_PATH}"]
      capture3!(*cmdline_run_analyzer)

      issues = parse_result_file(File.open("#{ANALYSIS_LOGFILE_PATH}"))

      # generate a result instance
      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        issues.each do |issue|
          loc = Location.new(
            start_line: issue[:start_line],
            start_column: issue[:start_column],
            end_line: issue[:end_line],
            end_column: issue[:end_column]
          )
          result.add_issue Issue.new(
            path: relative_path(issue[:file]),
            location: loc,
            id: issue[:rule_id],
            message: issue[:message],
            links: [issue[:link]],
            object: {
              level: issue[:level]
            }
          )
        end
      end
    end

    # parse error log file(static analysis log file) from .NET Core Compilers
    def parse_result_file(f)
      json = JSON.parse(f.read)

      # parse rule information
      rules = {}
      json.fetch('runs').each do |i|
        rules.merge!(i.fetch('rules'))
      end

      # parse analysis results and extract information
      rval = []
      json.fetch('runs').each do |i|
        i.fetch('results').each do |i2|
          rule_id = i2.fetch('ruleId')
          message = i2.fetch('message')
          level = i2.fetch('level')
          loc_info = i2.fetch('locations').fetch(0).fetch('resultFile').fetch('region')
          file = i2.fetch('locations').fetch(0).fetch('resultFile').fetch('uri').sub(/^file:\/\//, '')
          link = rules.fetch(rule_id).fetch('helpUri')
          # skip issues if the rule id is NOT for FxCop Analyzers
          unless rule_id =~ RULE_ID_PATTERN
            next
          end
          rval.append(
            {
              file: file,
              rule_id: rule_id,
              link: link,
              message: message,
              level: level,
              start_line: loc_info.fetch('startLine'),
              start_column: loc_info.fetch('startColumn'),
              end_line: loc_info.fetch('endLine'),
              end_column: loc_info.fetch('endColumn')
            }
          )
        end
      end
      rval
    end
  end
end
