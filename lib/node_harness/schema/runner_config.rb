module NodeHarness
  module Schema
    RunnerConfig = _ = StrongJSON.new do
      # @type self: Types::RunnerConfig

      let :base, object(
        root_dir: string?,
      )

      let :git, enum(
        object(repo: string, branch: string),
        object(repo: string, tag: string),
        object(repo: string, ref: string),
      )

      let :ruby, (base.update_fields { |fields|
        fields[:gems] = array?(
          enum(
            string,
            object(name: string, version: string, source: string?),
            object(name: string, git: git),
          )
        )
      })

      let :npm, (base.update_fields { |fields| fields[:npm_install] = enum?(boolean, literal('development'), literal('production')) })
    end
  end
end
