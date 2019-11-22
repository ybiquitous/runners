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

  def test_prepare_from_http
    with_workspace do |workspace|
      workspace.send(:prepare_in_dir, :head, "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, workspace.working_dir)
      refute_empty workspace.working_dir.children
    end
  end

  def test_prepare_from_http_with_retry_on_cipher_error
    with_workspace do |workspace|
      stub(workspace).decrypt.with_any_args { raise OpenSSL::Cipher::CipherError }
      stub(workspace).retryable_sleep { 0 }
      assert_raises(OpenSSL::Cipher::CipherError) do
        workspace.send(:prepare_in_dir, :head, "https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, workspace.working_dir)
      end
      assert_equal 4, workspace.trace_writer.writer.count { |trace| trace[:message] == 'Retrying download...' }
    end
  end

  def test_prepare_from_http_with_retry_on_download_error
    with_workspace do |workspace|
      stub(Net::HTTP).get_response.with_any_args.yields(Net::HTTPResponse.new('1.1', 500, 'error'))
      stub(workspace).retryable_sleep { 0 }
      assert_raises(Workspace::DownloadError) do
        workspace.send(:prepare_in_dir, :head, "https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, workspace.working_dir)
      end
      assert_equal 4, workspace.trace_writer.writer.count { |trace| trace[:message] == 'Retrying download...' }
    end
  end

  def test_prepare_from_http_with_retry_on_net_open_timeout
    with_workspace do |workspace|
      stub(Net::HTTP).get_response.with_any_args { raise Net::OpenTimeout }
      stub(workspace).retryable_sleep { 0 }
      assert_raises(Net::OpenTimeout) do
        workspace.send(:prepare_in_dir, :head, "https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, workspace.working_dir)
      end
      assert_equal 4, workspace.trace_writer.writer.count { |trace| trace[:message] == 'Retrying download...' }
    end
  end

  def test_prepare_from_dir
    with_workspace do |workspace|
      archive_path = Pathname(__dir__) / "data"
      workspace.send(:prepare_in_dir, :head, archive_path.to_s, nil, workspace.working_dir)
      assert (workspace.working_dir / "empty.rb").file?
    end
  end

  def test_prepare_from_archive
    with_workspace do |workspace|
      archive_path = Pathname(__dir__) + "data/foo.tgz"
      workspace.send(:prepare_in_dir, :head, archive_path.to_s, nil, workspace.working_dir)
      assert (workspace.working_dir / "querly.gemspec").file?
    end
  end

  def test_prepare_from_encrypted_archive
    with_workspace do |workspace|
      archive_path = Pathname(__dir__) + "data/encrypted.tar.gz"
      workspace.send(:prepare_in_dir, :head, archive_path.to_s, "CfAlFi2Uq3aiS3qSnq3Wq0gQWieTbt3151Z+iFXnE3o=", workspace.working_dir)
      assert (workspace.working_dir / "querly.gemspec").file?
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
