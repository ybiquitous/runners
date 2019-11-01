module Runners
  module Schema
    Options = _ = StrongJSON.new do
      # @type self: Types::Options

      let :source, enum(
        object(head: string, head_key: string?, base: string, base_key: string?),
        object(head: string, head_key: string?),
      )

      let :payload, object(
        source: source,
        outputs: array?(string),
        ssh_key: string?,
      )
    end
  end
end