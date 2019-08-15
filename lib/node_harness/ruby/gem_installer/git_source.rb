module NodeHarness
  module Ruby
    class GemInstaller
      class GitSource
        attr_reader :repo, :ref, :branch, :tag

        def initialize(repo:, ref: nil, branch: nil, tag: nil)
          @repo = repo
          @ref = ref
          @branch = branch
          @tag = tag
        end

        def ==(other)
          other.is_a?(self.class) && other.repo == repo && other.ref == ref && other.branch == branch && other.tag == tag
        end

        def to_s
          "git #{repo.inspect}, ref: #{ref.inspect}, branch: #{branch.inspect}, tag: #{tag.inspect}"
        end
      end
    end
  end
end
