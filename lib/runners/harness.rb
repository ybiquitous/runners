module Runners
  class Harness
    class InvalidResult < StandardError
      # @dynamic result
      attr_reader :result

      def initialize(result:)
        super("Invalid result: #{result.inspect}")
        @result = result
      end
    end

    # @dynamic guid, processor_class, options, working_dir, trace_writer, warnings, ci_config
    attr_reader :guid
    attr_reader :processor_class
    attr_reader :options
    attr_reader :working_dir
    attr_reader :trace_writer
    attr_reader :warnings
    attr_reader :ci_config

    def initialize(guid:, processor_class:, options:, working_dir:, trace_writer:)
      @guid = guid
      @processor_class = processor_class
      @options = options
      @working_dir = working_dir
      @trace_writer = trace_writer
      @warnings = []
    end

    def run
      ensure_result do
        Workspace.open(base: options.base, base_key: options.base_key,
                       head: options.head, head_key: options.head_key,
                       ssh_key: options.ssh_key, working_dir: working_dir, trace_writer: trace_writer) do |workspace|

          begin
            instance = processor_class.new(guid: guid, working_dir: workspace.working_dir, git_ssh_path: workspace.git_ssh_path, trace_writer: trace_writer)

            root_dir_not_found = instance.check_root_dir_exist
            return root_dir_not_found if root_dir_not_found

            instance.push_root_dir do
              trace_writer.header "Calculating changes between head and base"
              changes = trace_writer.message "Running..." do
                workspace.calculate_changes
              end

              trace_writer.header "Setting up analyzer"

              result = instance.setup do
                trace_writer.header "Running analyzer"
                instance.analyze(changes)
              end

              case result
              when Results::Success
                trace_writer.message "Removing issues from unchanged or untracked files..." do
                  changed_paths = Set.new(changes.changed_files.map(&:path))
                  result.filter_issue { |issue| changed_paths.member?(issue.path) }
                end
              else
                result
              end
            end
          ensure
            @warnings = instance&.warnings || []
            @ci_config = instance&.ci_config_for_collect
          end
        end
      end
    end

    def ensure_result
      begin
        yield.tap do |result|
          unless result.valid?
            raise InvalidResult.new(result: result)
          end
        end
      rescue => exn
        Bugsnag.notify(exn)
        handle_error(exn)
        Results::Error.new(guid: guid, exception: exn)
      end
    end

    def handle_error(exn)
      case exn
      when InvalidResult
        # Do nothing because this is an internal logic error.
      else
        trace_writer.error "#{exn.message} (#{exn.class})"
      end
    end
  end
end
