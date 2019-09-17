module Runners
  class Shell
    class ExecError < StandardError
      # @dynamic type, args, stdout_str, stderr_str, status, dir
      attr_reader :type
      attr_reader :args
      attr_reader :stdout_str
      attr_reader :stderr_str
      attr_reader :status
      attr_reader :dir

      def initialize(type:, args:, stdout_str:, stderr_str:, status:, dir:)
        @type = type
        @args = args
        @stdout_str = stdout_str
        @stderr_str = stderr_str
        @status = status
        @dir = dir
      end

      def inspect
        "#<#{self.class.name}: type=#{type}, args=#{args.inspect}, status=#{status.inspect}, dir=#{dir.inspect}, stdout_str=..., stderr_str=...>"
      end
    end

    attr_reader :trace_writer
    attr_reader :dir_stack
    attr_reader :env_hash_stack

    def initialize(current_dir:, trace_writer:, env_hash:)
      @trace_writer = trace_writer
      @dir_stack = [current_dir]
      @env_hash_stack = [env_hash]
    end

    def current_dir
      dir_stack.last or raise "Empty dir stack"
    end

    def push_dir(dir)
      dir_stack.push dir
      yield
    ensure
      dir_stack.pop
    end

    def push_env_hash(env)
      env_hash_stack.push(env)
      yield
    ensure
      env_hash_stack.pop
    end

    def env_hash
      env_hash_stack.inject({}) do |acc, env|
        # @type var acc: Hash<String, String?>
        acc.merge(env)
      end
    end

    def capture3(command, *args)
      capture3_trace(command, *args)
    end

    def capture3!(command, *args)
      stdout, stderr, status = capture3_trace(command, *args)

      unless status.success?
        raise ExecError.new(type: :capture3,
                            args: [command] + args,
                            stdout_str: stdout,
                            stderr_str: stderr,
                            status: status,
                            dir: current_dir)
      end

      [stdout, stderr]
    end

    def capture3_with_retry!(command, *args, tries: 3)
      Retryable.retryable(
        tries: tries,
        on: ExecError,
        sleep: -> (n) { n + 1 },
        exception_cb: -> (_ex) { trace_writer.message "Command failed. Retrying..." }
      ) do
        capture3!(command, *args)
      end
    end

    def capture3_trace(command, *args)
      trace_writer.command_line([command] + args)

      Open3.capture3(env_hash, command, *args, { chdir: current_dir.to_s }).tap do |stdout_str, stderr_str, status|
        trace_writer.stdout stdout_str
        trace_writer.stderr stderr_str
        if status.exited?
          trace_writer.status status
        else
          trace_writer.error "Process aborted or coredumped: #{status.inspect}"
        end
      end
    end
  end
end
