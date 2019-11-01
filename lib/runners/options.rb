module Runners
  class Options
    attr_reader :stdout, :stderr
    attr_reader :head, :head_key, :base, :base_key, :ssh_key, :io

    def initialize(stdout, stderr)
      @stdout = stdout
      @stderr = stderr

      options = parse_options
      outputs = options[:outputs] || []
      @head = options.dig(:source, :head)
      @head_key = options.dig(:source, :head_key)
      @base = options.dig(:source, :base)
      @base_key = options.dig(:source, :base_key)
      @ssh_key = options[:ssh_key]
      @io = if outputs.empty?
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
                  raise "Invalid output option. You included '#{output}'"
                end
              end
              Runners::IO.new(*ios)
            end
    end

    private

    def parse_options
      ENV['RUNNERS_OPTIONS'].yield_self do |val|
        Schema::Options.payload.coerce(JSON.parse(val, symbolize_names: true))
      end
    end
  end
end
