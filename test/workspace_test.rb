require_relative "test_helper"

class WorkspaceTest < Minitest::Test
  include TestHelper

  Workspace = Runners::Workspace

  def test_open
    with_workspace do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert (workspace.working_dir + "querly.gemspec").file?
        refute (workspace.working_dir + "foo.tgz").file?

        refute changes.changed_files.empty?
        refute changes.unchanged_paths.empty?
        assert changes.untracked_paths.empty?
      end
    end
  end

  def test_open_without_base
    with_workspace(base: nil, base_key: nil) do |workspace|
      workspace.open do |_git_ssh_path, changes|
        assert (workspace.working_dir + "querly.gemspec").file?
        refute (workspace.working_dir + "foo.tgz").file?

        refute changes.changed_files.empty?
        assert changes.unchanged_paths.empty?
        assert changes.untracked_paths.empty?
      end
    end
  end

  def test_git_ssh_path_is_nil
    with_workspace do |workspace|
      workspace.open do |git_ssh_path|
        assert_nil git_ssh_path
      end
    end
  end

  def test_git_ssh_path_is_pathname
    with_workspace(ssh_key: (Pathname(__dir__) / "data/ssh_key").read) do |workspace|
      workspace.open do |git_ssh_path|
        refute_nil git_ssh_path

        Open3.capture3(
          { "GIT_SSH" => git_ssh_path.to_s },
          "git", "clone", "--depth=1", "git@github.com:sideci/go_private_library.git",
          { chdir: workspace.working_dir.to_s }
        )
        assert (workspace.working_dir / "go_private_library/main.go").file?
      end
    end
  end
end
