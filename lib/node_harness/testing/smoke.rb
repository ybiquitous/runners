require "minitest"
require "unification_assertion"
require "pp"
require "node_harness/schema/result"
require 'parallel'

module NodeHarness
  module Testing
    class Smoke
      include UnificationAssertion

      ROOT_DATA_DIR = Pathname('/data')

      attr_reader :argv, :data_container, :data_smoke_path

      Configuration = Struct.new(:ssh_key)

      def docker_image
        argv[0]
      end

      def entrypoint
        Pathname(argv[0])
      end

      def expectations
        Pathname(argv[1])
      end

      def initialize(argv)
        @argv = argv
        @data_container = 'data-container'
        @data_smoke_path = ROOT_DATA_DIR / expectations.parent.basename
      end

      def run
        load expectations

        threads = ENV["JOBS"]&.to_i || Parallel.processor_count * 2
        results = with_data_container do
          Parallel.map(self.class.tests, in_threads: threads) do |name, pattern|
            out = StringIO.new(''.dup)
            result = run_test(name, pattern, out)
            print out.string
            result
          end
        end

        puts "-" * 30
        if results.all?
          puts "❤️  Smoke tests pass!"
        else
          puts "⚠️  Smoke test failed"
          exit 1
        end
      end

      # @return [true|false] Status of the test case
      def run_test(name, pattern, out)
        return true if ENV['ONLY'] && ENV['ONLY'] != name
        commandline = command_line(name, self.class.configs[name])
        out.puts "$ #{commandline}"
        reader = JSONSEQ::Reader.new(io: StringIO.new(`#{commandline}`), decoder: -> (json) { JSON.parse(json, symbolize_names: true) })
        traces = reader.each_object.to_a
        if ENV['SHOW_TRACE']
          traces.each do |trace|
            out.puts trace.pretty_inspect
          end
        end
        result = traces.find { |object|
          NodeHarness::Schema::Result.envelope =~ object
        }

        unify_result(result, pattern, out)
      end

      def unify_result(result, pattern, out)
        ok = true
        unify [[result, pattern, ""]] do |a, b, path|
          case
          when (a.is_a?(Regexp) && !b.is_a?(Regexp)) || (!a.is_a?(Regexp) && b.is_a?(Regexp))
            unless a.match?(b)
              ok = false
              out.puts "Pattern matching failed: #{path}, #{a.inspect}, #{b.inspect}"
            end
          else
            unless a == b
              ok = false
              out.puts "Pattern matching failed: #{path}, #{a.inspect}, #{b.inspect}"
            end
          end
        end
        out.puts result.pretty_inspect unless ok

        ok
      end

      def with_data_container
        system "docker run --name #{data_container} -v #{ROOT_DATA_DIR} alpine:latest true"
        system "docker cp #{expectations.parent} #{data_container}:#{ROOT_DATA_DIR}"
        yield
      ensure
        system "docker rm --force #{data_container}"
      end

      def command_line(name, config)
        dir = data_smoke_path + name
        commands = %W[docker run --rm --volumes-from #{data_container} #{docker_image} --head=#{dir.expand_path}]
        commands << "--ssh-key=#{dir.expand_path + config.ssh_key}" if config.ssh_key
        commands << "test-guid"
        commands.join(" ")
      end

      @tests = {}
      @configs = {}

      def self.add_test(name, result, **others)
        others[:'harness-version'] ||= :_
        others[:warnings] ||= []
        others[:ci_config] ||= :_

        @tests[name] = {
          result: result,
          **others,
        }
        @configs[name] = Configuration.new

        yield @configs[name] if block_given?
      end

      def self.tests
        @tests
      end

      def self.configs
        @configs
      end
    end
  end
end
