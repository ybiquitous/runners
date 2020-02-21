module Runners
  # A processor class for FxCop Analyzers
  # https://docs.microsoft.com/en-us/visualstudio/code-quality/install-fxcop-analyzers
  # This is a beta release. We support only repositories that has .csproj file directly under analysis root directory.
  class Processor::FxCop < Processor
    #parameters
    FXCOP_ANALYZER_VERSION = ENV['FXCOP_VERSION']
    ANALYSIS_LOGFILE_PATH = '/tmp/sider_analysis_out.json'.freeze
    RULE_ID_PATTERN = /CA[0-9]+/.freeze

    Schema = StrongJSON.new do
      let :issue, object(
        severity: string?,
        )
    end

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
      unless status.success?
        msg = <<~EOS
          Failed to restore .NET Core Project. You have to put project file (.csproj) under the analysis root. Please check the project structure and 'root_dir' parameter in #{ci_config_path_name}.
          See: https://help.sider.review/getting-started/custom-configuration#root_dir-option
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

      issues = parse_result(File.read(ANALYSIS_LOGFILE_PATH))

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
              severity: issue[:level]
            },
            schema: Schema.issue
          )
        end
      end
    end

    # parse error log (static analysis log) from .NET Core Compilers
    def parse_result(f)
      json = JSON.parse(f, {:symbolize_names => true})

      # parse rule information
      rules = json[:runs].each_with_object({}){|i,v| v.merge!(i[:rules])}

      # parse analysis results and extract information
      rval = []
      json[:runs].each do |i|
        i[:results].each do |i2|
          rule_id = i2[:ruleId]
          message = i2[:message]
          level = i2[:level]
          loc_info = i2.dig(:locations,0,:resultFile, :region)
          file = i2.dig(:locations, 0, :resultFile, :uri).yield_self{|s| URI.parse(s).path}
          link = rules[rule_id.intern][:helpUri]
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
              start_line: loc_info[:startLine],
              start_column: loc_info[:startColumn],
              end_line: loc_info[:endLine],
              end_column: loc_info[:endColumn]
            }
          )
        end
      end
      rval
    end
  end
end
