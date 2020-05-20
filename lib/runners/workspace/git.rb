module Runners
  class Workspace::Git < Workspace
    def range_git_blame_info(path_string, start_line, end_line)
      stdout, _ = shell.capture3!("git", "blame", "-p", "-L", "#{start_line},#{end_line}", git_source.head, "--", path_string,
                                  trace_stdout: false, trace_stderr: true)
      GitBlameInfo.parse(stdout)
    end

    private

    def prepare_base_source(_dest)
      # noop
    end

    def prepare_head_source(_dest)
      shell.capture3!("git", "init")
      shell.capture3!("git", "config", "gc.auto", "0")
      shell.capture3!("git", "config", "advice.detachedHead", "false")
      shell.capture3!("git", "remote", "add", "origin", remote_url.to_s)
      shell.capture3!("git", "fetch", *git_fetch_args)
      shell.capture3!("git", "checkout", git_source.head)
    end

    def remote_url
      @remote_url ||= URI.join(git_source.git_http_url, "#{git_source.owner}/#{git_source.repo}").tap do |uri|
        git_http_userinfo = git_source.git_http_userinfo
        uri.userinfo = git_http_userinfo if git_http_userinfo
      end
    end

    def git_fetch_args
      @git_fetch_args ||= %w[--quiet --no-tags --no-recurse-submodules origin].tap do |command|
        command << "+refs/heads/*:refs/remotes/origin/*"

        num = git_source.pull_number
        command << "+refs/pull/#{num}/head:refs/remotes/pull/#{num}/head" if num
      end
    end

    def patches
      return @patches if defined? @patches

      base = git_source.base
      head = git_source.head

      @patches =
        if base && head
          # NOTE: We should use `...` (triple-dot) instead of `..` (double-dot). See https://git-scm.com/docs/git-diff
          stdout, _ = shell.capture3!("git", "diff", "#{base}...#{head}", trace_stdout: false)
          GitDiffParser.parse(stdout)
        end
    end
  end
end
