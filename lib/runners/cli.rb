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
    attr_reader :s3_uri
    attr_reader :outputs

    def initialize(argv:, stdout:, stderr:)
      @stdout = stdout
      @stderr = stderr
      @outputs = []
      @base = ENV['BASE']
      @base_key = ENV['BASE_KEY']
      @head = ENV['HEAD']
      @head_key = ENV['HEAD_KEY']

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
          warn '--ssh-key is deprecated. Use the environment variable `BASE64_SSH_KEY`'
          @ssh_key = ssh_key
        end
        opts.on("--working=WORKING") do |working|
          @working_dir = working
        end
        opts.on("--output=OUTPUT",
                "The output destination. Currently, the valid formats are 'stdout', 'stderr', and 's3://BUCKET/KEY'") do |output|
          @outputs << output
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
        writer = JSONSEQ::Writer.new(io: io)
        trace_writer = TraceWriter.new(writer: writer)
        trace_writer.header "Analysis started"

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
          result.tap do
            trace_writer.header "Analysis finished"
          end
        end
      ensure
        io.finalize! if defined?(:@io)
      end
    end

    def io
      @io ||= if outputs.empty?
                Runners::IO.new(stdout)
              else
                ios = outputs.map do |output|
                  case output
                  when 'stdout'
                    stdout
                  when 'stderr'
                    stderr
                  when /^s3:/
                    Runners::IO::AwsS3.new(output)
                  else
                    raise "Invalid output option. You set with '--output=#{output}'"
                  end
                end
                Runners::IO.new(*ios)
              end
    end
  end
end
