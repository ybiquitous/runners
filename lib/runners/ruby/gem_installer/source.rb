module Runners
  module Ruby::GemInstaller::Source
    def self.create(gems_item)
      source = gems_item["source"]
      git = gems_item["git"]

      case
      when source.is_a?(String)
        # @type var source: String
        source = source
        Rubygems.new(source)
      when git.is_a?(Hash)
        # @type var git: Ruby::git_source
        git = git
        if git["repo"]
          Git.new(repo: git["repo"], ref: git["ref"], branch: git["branch"], tag: git["tag"])
        else
          raise ArgumentError.new("Unexpected gem: #{gems_item.inspect}")
        end
      else
        Rubygems.new
      end
    end

    class Base
      def rubygems?
        false
      end

      def git?
        false
      end

      def eql?(other)
        other.class == self.class && other.to_s == to_s
      end
    end

    class Rubygems < Base
      attr_reader :source

      def initialize(source = Ruby::GemInstaller::DEFAULT_SOURCE)
        @source = source
      end

      def rubygems?
        true
      end

      def ==(other)
        other.class == self.class && other.source == source
      end

      def to_s
        "source #{source.inspect}"
      end
    end

    class Git < Base
      attr_reader :repo, :ref, :branch, :tag

      def initialize(repo:, ref: nil, branch: nil, tag: nil)
        @repo = repo
        @ref = ref
        @branch = branch
        @tag = tag
      end

      def git?
        true
      end

      def ==(other)
        other.class == self.class && other.repo == repo && other.ref == ref && other.branch == branch && other.tag == tag
      end

      def to_s
        "git #{repo.inspect}, ref: #{ref.inspect}, branch: #{branch.inspect}, tag: #{tag.inspect}"
      end
    end
  end
end
