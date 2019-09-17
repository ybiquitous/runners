require "optparse"

module Runners
  class CLI
    attr_reader :stdout
    attr_reader :stderr
    attr_reader :guid
    attr_reader :analyzer
    attr_reader :base
    attr_reader :base_key
    attr_reader :head
    attr_reader :head_key
    attr_reader :ssh_key
    attr_reader :working_dir

    def initialize(argv:, stdout:, stderr:)
      @stdout = stdout
      @stderr = stderr

      OptionParser.new do |opts|
        opts.on("--analyzer=ANALYZER") do |analyzer|
          @analyzer = analyzer
        end
        opts.on("--base=BASE") do |base|
          @base = base
        end
        opts.on("--base-key=BASE_KEY") do |base_key|
          @base_key = base_key
        end
        opts.on("--head=HEAD") do |head|
          @head = head
        end
        opts.on("--head-key=HEAD_KEY") do |head_key|
          @head_key = head_key
        end
        opts.on("--ssh-key=SSH_KEY") do |ssh_key|
          @ssh_key = ssh_key
        end
        opts.on("--working=WORKING") do |working|
          @working_dir = working
        end
      end.parse!(argv)

      @guid = _ = argv.shift
    end

    def with_working_dir
      if (w = working_dir)
        path = Pathname(w)
        path.mkpath
        yield path
      else
        Dir.mktmpdir do |dir|
          yield Pathname(dir)
        end
      end
    end

    def validate_options!
      case
      when base && head
        # ok
      when !base && head
        # ok
      else
        raise "--head is required while --base is optional (base=#{base}, head=#{head})"
      end

      raise "base_key is given but base is missing" if !base && base_key
      raise "head_key is given but head is missing" if !head && head_key
      validate_analyzer!
      self
    end

    def validate_analyzer!
      raise "--analyzer is required" unless analyzer
      raise "The specified analyzer is not supported" unless processor_class
    end

    def processor_class
      @processor_class ||= (Processor.subclasses.detect do |cls|
        "#{Processor.name}::#{analyzer.to_s.delete('_')}".casecmp?(cls.name)
      end or raise "Not found processor class with '#{analyzer}'")
    end

    def run
      with_working_dir do |working_dir|
        writer = JSONSEQ::Writer.new(io: stdout)
        trace_writer = TraceWriter.new(writer: writer)

        Workspace.open(base: base, base_key: base_key, head: head, head_key: head_key, ssh_key: ssh_key, working_dir: working_dir, trace_writer: trace_writer) do |workspace|
          harness = Harness.new(guid: guid, processor_class: processor_class, workspace: workspace, trace_writer: trace_writer)

          result = harness.run
          warnings = harness.warnings
          ci_config = harness.ci_config
          json = {
            result: result.as_json,
            warnings: warnings,
            ci_config: ci_config,
          }

          trace_writer.message "Writing result..." do
            writer << Schema::Result.envelope.coerce(json)
          end
        end
      end
    end
  end
end
