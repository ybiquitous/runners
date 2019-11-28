require_relative "../test_helper"

class WorkspaceGitTest < Minitest::Test
  include TestHelper

  def test_prepare_head_source
    with_workspace(head: "998bc02a913e3899f3a1cd327e162dd54d489a4b",
                   git_http_url: "https://github.com", owner: "sider", repo: "runners", pull_number: 533) do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
      mktmpdir do |dest|
        workspace.send(:prepare_head_source, dest)
        refute_empty dest.children
        assert (dest / "README.md").file?
        refute (dest / ".git").exist?
      end
    end
  end

  def test_prepare_base_source_raise_if_base_is_nil
    with_workspace(head: "998bc02a913e3899f3a1cd327e162dd54d489a4b",
                   git_http_url: "https://github.com", owner: "sider", repo: "runners", pull_number: 533) do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
      mktmpdir do |dest|
        assert_raises(ArgumentError) do
          workspace.send(:prepare_base_source, dest)
        end
      end
    end
  end

  def test_remote_url
    with_workspace(head: "commit",
                   git_http_url: "https://github.example.com", owner: "foo", repo: "bar") do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
      assert_equal URI("https://github.example.com/foo/bar"), workspace.send(:remote_url)
    end
  end

  def test_remote_url_with_token
    with_workspace(head: "commit",
                   git_http_url: "https://github.com", owner: "foo", repo: "bar",
                   git_http_userinfo: "x-access-token:v1.aaabbbcccdddeeefffgggbc06400127f248a82ac") do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
      assert_equal URI("https://x-access-token:v1.aaabbbcccdddeeefffgggbc06400127f248a82ac@github.com/foo/bar"), workspace.send(:remote_url)
    end
  end

  def test_git_fetch_args
    with_workspace(head: "998bc02a913e3899f3a1cd327e162dd54d489a4b",
                   git_http_url: "https://github.com", owner: "sider", repo: "runners", pull_number: 533) do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
      assert_equal %w[fetch --no-tags --no-recurse-submodules origin
                          +refs/heads/*:refs/remotes/origin/* +refs/pull/533/head:refs/remotes/pull/533/head], workspace.send(:git_fetch_args)
    end

    with_workspace(head: "998bc02a913e3899f3a1cd327e162dd54d489a4b",
                   git_http_url: "https://github.com", owner: "sider", repo: "runners") do |workspace|
      assert_instance_of Runners::Workspace::Git, workspace
      assert_equal %w[fetch --no-tags --no-recurse-submodules origin
                          +refs/heads/*:refs/remotes/origin/*], workspace.send(:git_fetch_args)
    end
  end
end
