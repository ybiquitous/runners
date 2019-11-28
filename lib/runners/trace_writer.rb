module Runners
  class TraceWriter
    attr_reader :writer, :sensitive_strings

    def initialize(writer:, sensitive_strings: [])
      @writer = writer
      @sensitive_strings = sensitive_strings
    end

    def command_line(command_line, recorded_at: Time.now)
      self << { trace: 'command_line', command_line: command_line.map { |v| masked_string(v) }, recorded_at: recorded_at.utc.iso8601 }
    end

    def status(status, recorded_at: Time.now)
      self << { trace: 'status', status: status.exitstatus, recorded_at: recorded_at.utc.iso8601 }
    end

    def stdout(string, recorded_at: Time.now, max_length: 4_000)
      unless string.empty?
        each_slice(masked_string(string), size: max_length) do |text|
          self << { trace: 'stdout', string: text, recorded_at: recorded_at.utc.iso8601 }
        end
      end
    end

    def stderr(string, recorded_at: Time.now, max_length: 4_000)
      unless string.empty?
        each_slice(masked_string(string), size: max_length) do |text|
          self << { trace: 'stderr', string: text, recorded_at: recorded_at.utc.iso8601 }
        end
      end
    end

    # @type method message: (String, ?recorded_at: Time, ?max_length: Integer) ?{ -> any } -> any
    def message(message, recorded_at: Time.now, max_length: 4_000)
      each_slice(masked_string(message), size: max_length) do |text|
        self << { trace: 'message', message: text, recorded_at: recorded_at.utc.iso8601 }
      end
      if block_given?
        start = Time.now
        yield.tap do
          duration = Time.now - start
          self << { trace: 'message', message: "    -> #{format_duration_in_secs(duration)}s", recorded_at: (recorded_at + duration).utc.iso8601 }
        end
      end
    end

    def header(message, recorded_at: Time.now)
      self << { trace: 'header', message: masked_string(message), recorded_at: recorded_at.utc.iso8601 }
    end

    def warning(message, file: nil, recorded_at: Time.now)
      self << { trace: 'warning', file: file, message: masked_string(message), recorded_at: recorded_at.utc.iso8601 }
    end

    def ci_config(content, recorded_at: Time.now)
      self << { trace: 'ci_config', content: content, recorded_at: recorded_at.utc.iso8601 }
    end

    def error(message, recorded_at: Time.now, max_length: 4_000)
      each_slice(masked_string(message), size: max_length) do |text|
        self << { trace: 'error', message: text, recorded_at: recorded_at.utc.iso8601 }
      end
    end

    def <<(object)
      writer << Schema::Trace.anything.coerce(object)
    end

    private

    def each_slice(string, size:)
      string = string.dup

      while string.length > 0
        slice = string.slice!(0, size)
        if slice.length == size
          yield(slice + "\\")
        else
          yield slice
        end
      end
    end

    def format_duration_in_secs(duration)
      duration.ceil(4).to_s
    end

    def masked_string(str)
      sensitive_strings.inject(str) do |ret, secure_string|
        ret.gsub(secure_string, "[FILTERED]")
      end
    end
  end
end
