module Runners
  class Processor::Goodcheck < Processor
    include Ruby

    attr_reader :analyzer

    Schema = StrongJSON.new do
      let :rule, object(
        id: string,
        message: string,
        justifications: array(string),
      )

      let :runner_config, Schema::RunnerConfig.ruby.update_fields { |fields|
        fields.merge!({
                        config: string?,
                        target: optional(enum(string, array(string)))
                      })
      }.freeze
    end

    DEFAULT_GEMS = [
      GemInstaller::Spec.new(name: "goodcheck", version: ["2.4.0"]),
    ].freeze

    CONSTRAINTS = {
      "goodcheck" => [">= 1.0.0", "< 3.0"]
    }.freeze

    def self.ci_config_section_name
      "goodcheck"
    end

    def ensure_config
      ensure_runner_config_schema(Schema.runner_config) do |config|
        if config[:config]
          yield config
        else
          ensure_files relative_path("goodcheck.yml") do
            yield config
          end
        end
      end
    end

    def goodcheck_test(config)
      stdout, _, status = capture3("bundle", "exec", "goodcheck", "test", *(config[:config] ? ["--config", config[:config]] : []))

      if !status.success? && !stdout.empty?
        msg = <<~MESSAGE.chomp
          Goodcheck configuration validation failed.
          Check the following output by `goodcheck test` command.

          #{stdout}
        MESSAGE
        add_warning(msg, file: config[:config] || "goodcheck.yml")
      end

      yield
    end

    def goodcheck_check(config)
      targets = Array(config[:target]) || ["."]
      config = config[:config]
      args = (config ? ["--config", config] : []) + targets

      stdout, stderr, _ = capture3("bundle", "exec", "goodcheck", "check", "--format=json", *args)

      json = JSON.parse(stdout, symbolize_names: true)

      stderr.each_line do |line|
        case line
        when /\[Warning\] (.+)$/
          add_warning $1
        end
      end

      Results::Success.new(guid: guid, analyzer: analyzer).tap do |result|
        json.each do |hash|
          id = hash[:rule_id]
          path = relative_path(hash[:path])

          # When the `not` rule detects issues, `location` is null.
          # @see https://github.com/sider/goodcheck/pull/49/files#r281913022
          if hash[:location]
            location = Location.new(start_line: hash[:location][:start_line],
                                                 start_column: hash[:location][:start_column],
                                                 end_line: hash[:location][:end_line],
                                                 end_column: hash[:location][:end_column])
          else
            location = nil
          end

          object = {
            id: id,
            message: hash[:message],
            justifications: hash[:justifications]
          }

          issue = Issues::Structured.new(
            path: path,
            location: location,
            id: id,
            object: object,
            schema: Schema.rule
          )

          result.add_issue issue
        end
      end
    end

    def setup
      ret = ensure_runner_config_schema(Schema.runner_config) do
        show_ruby_runtime_versions
        install_gems DEFAULT_GEMS, constraints: CONSTRAINTS do |versions|
          @analyzer = Analyzer.new(name: 'goodcheck', version: versions["goodcheck"])
          yield
        end
      end

      # NOTE: Exceptionally MissingFileFailure is treated as successful
      if ret.instance_of? Results::MissingFilesFailure
        trace_writer.error "File not found: goodcheck.yml"
        add_warning(<<~MESSAGE)
          Sider cannot find the required configuration file `goodcheck.yml`.
          Please set up Goodcheck by following the instructions, or you can disable it in the repository settings.

          - https://github.com/sider/goodcheck
          - https://help.sider.review/tools/others/goodcheck
        MESSAGE
        Results::Success.new(guid: guid, analyzer: analyzer)
      else
        ret
      end
    rescue InstallGemsFailure => exn
      trace_writer.error exn.message
      return Results::Failure.new(guid: guid, message: exn.message, analyzer: nil)
    end

    def analyze(changes)
      delete_unchanged_files(changes, except: ["*.yml", "*.yaml"])

      capture3!("bundle", "exec", "goodcheck", "version")

      ensure_config do |config|
        goodcheck_test config do
          goodcheck_check config
        end
      end
    end
  end
end
