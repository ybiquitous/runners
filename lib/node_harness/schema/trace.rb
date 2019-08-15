module NodeHarness
  module Schema
    Trace = _ = StrongJSON.new do
      # @type self: Types::Trace
      let :command_line, object(trace: literal("command_line"), command_line: array(string), recorded_at: string)
      let :status, object(trace: literal("status"), status: number, recorded_at: string)
      let :stdout, object(trace: literal("stdout"), string: string, recorded_at: string)
      let :stderr, object(trace: literal("stderr"), string: string, recorded_at: string)
      let :message, object(trace: literal("message"), message: string, recorded_at: string)
      let :header, object(trace: literal("header"), message: string, recorded_at: string)
      let :warning, object(trace: literal("warning"), message: string, file: string?, recorded_at: string)
      let :ci_config, object(trace: literal("ci_config"), content: any, recorded_at: string)
      let :error, object(trace: literal("error"), message: string, recorded_at: string)
      let :anything, enum(command_line, status, stdout, stderr, message, header, warning, ci_config, error)
    end
  end
end
