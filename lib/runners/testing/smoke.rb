require "minitest"
require "unification_assertion"
require "pp"
require 'parallel'
require "amazing_print"

module Runners
  module Testing
    class Smoke
      include Minitest::Assertions
      include UnificationAssertion
      include Tmpdir

      PROJECT_PATH = "/project".freeze

      attr_reader :argv

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
      end

      def run
        load expectations.to_s

        threads = ENV["JOBS"]&.to_i || Parallel.processor_count * 2
        results = Parallel.map(self.class.tests, in_threads: threads) do |name, pattern|
          out = StringIO.new(''.dup)
          result = run_test(name, pattern, out)
          print out.string
          [result, name]
        end

        abort "❌ No smoke tests!" if results.empty?

        passed = results.count { |result,| result == :passed }
        failed = results.count { |result,| result == :failed }
        total = results.count
        summary = "#{passed} passed, #{failed} failed, #{total} total"

        puts "-" * 30
        if failed == 0
          puts "❤️  Smoke tests passed! -- #{summary}"
        else
          puts "❌ Smoke tests failed! -- #{summary}"
          marks = { passed: '✅', failed: '❌' }
          results.each { |result, name| puts "--> #{marks.fetch(result)} #{name}" }
          exit 1
        end
      end

      def run_test(name, pattern, out)
        commandline = command_line(name)
        out.puts "$ #{commandline}"
        reader = JSONSEQ::Reader.new(io: StringIO.new(`#{commandline}`), decoder: -> (json) { JSON.parse(json, symbolize_names: true) })
        traces = reader.each_object.to_a
        if ENV['SHOW_TRACE']
          traces.each do |trace|
            out.puts colored_pretty_inspect(trace)
          end
        end
        result = traces.find { |object|
          Schema::Result.envelope =~ object
        }

        unify_result(result, pattern, out) ? :passed : :failed
      end

      def unify_result(result, pattern, out)
        ok = true
        unify [[result, pattern, ""]] do |a, b, path|
          case
          when (a.is_a?(Regexp) && !b.is_a?(Regexp)) || (!a.is_a?(Regexp) && b.is_a?(Regexp))
            unless a.match?(b)
              ok = false
              out.puts "❌ Pattern matching failed at #{path}:"
              out.puts diff(b, a)
            end
          else
            unless a == b
              ok = false
              out.puts "❌ Pattern matching failed at #{path}:"
              out.puts diff(b, a)
            end
          end
        end
        out.puts colored_pretty_inspect(result) unless ok

        ok
      end

      def command_line(name)
        smoke_target = (expectations.parent / name).realpath
        runners_options = JSON.dump(source: { head: PROJECT_PATH })
        commands = %W[docker run --rm --mount type=bind,source=#{smoke_target},target=#{PROJECT_PATH} --env RUNNERS_OPTIONS='#{runners_options}' #{docker_image} test-guid]
        commands.join(" ")
      end

      def system!(*command_args)
        system(*command_args, exception: true)
      end

      def colored_pretty_inspect(hash)
        hash.awesome_inspect(indent: 2, index: false)
      end

      @tests = {}

      def self.tests
        @tests
      end

      # Comma-separated value is also available.
      def self.only?(name)
        value = ENV["ONLY"]
        if value
          value.split(",").map(&:strip).include?(name)
        else
          true
        end
      end

      def self.add_test(name, type:, guid: "test-guid", timestamp: :_,
                        issues: nil, message: nil, analyzer: nil,
                        class: nil, backtrace: nil, inspect: nil,
                        warnings: [], ci_config: :_, version: :_)
        return unless only? name

        optional = {
          issues: issues,
          message: message,
          analyzer: analyzer,
          class: binding.local_variable_get(:class),
          backtrace: backtrace,
          inspect: inspect,
        }.compact

        tests[name] = {
          result: { guid: guid, timestamp: timestamp, type: type, **optional },
          warnings: warnings,
          ci_config: ci_config,
          version: version,
        }
      end
    end
  end
end
