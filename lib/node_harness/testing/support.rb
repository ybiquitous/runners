module NodeHarness
  module Testing
    module Support
      def processor(head_dir:, base_dir: nil)
        klass = NodeHarness.processor

        io = StringIO.new
        writer = JSONSEQ::Writer.new(io: io)
        trace_writer = TraceWriter.new(writer: writer)

        Dir.mktmpdir do |working_dir|
          path = Pathname(working_dir)
          Workspace.open(base: base_dir&.to_s, base_key: nil, head: head_dir.to_s, head_key: nil, ssh_key: nil, trace_writer: trace_writer, working_dir: path) do |workspace|
            yield klass.new(guid: SecureRandom.uuid, trace_writer: trace_writer, git_ssh_path: workspace.git_ssh_path, working_dir: path), workspace.calculate_changes
          end
        end
      end
    end
  end
end
