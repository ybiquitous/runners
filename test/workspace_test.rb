require_relative "test_helper"

class WorkspaceTest < Minitest::Test
  include TestHelper

  Workspace = Runners::Workspace

  def trace_writer
    @trace_writer ||= Runners::TraceWriter.new(writer: [])
  end

  def test_prepare_from_http
    mktmpdir do |path|
      Workspace.prepare_in_dir(:dummy, "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, path, trace_writer: trace_writer)

      # GitHub tarball contains directory, so that we cannot test existence of files in repository
      refute_empty path.children
    end
  end

  def test_prepare_from_http_with_retry_on_cipher_error
    stub(Workspace).decrypt {raise OpenSSL::Cipher::CipherError}
    assert_raises(OpenSSL::Cipher::CipherError) do
      mktmpdir do |path|
        Workspace.prepare_in_dir(:dummy, "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, path, trace_writer: trace_writer)
      end
    end
    assert_equal 4, trace_writer.writer.count {|trace| trace[:message] == 'Retrying download...'}
  end

  def test_prepare_from_http_with_retry_on_download_error
    stub(Net::HTTP).get_response.with_any_args.yields(Net::HTTPResponse.new('1.1', 500, 'error'))
    assert_raises(Workspace::DownloadError) do
      mktmpdir do |path|
        Workspace.prepare_in_dir(:dummy, "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, path, trace_writer: trace_writer)
      end
    end
    assert_equal 4, trace_writer.writer.count {|trace| trace[:message] == 'Retrying download...'}
  end

  def test_prepare_from_http_with_retry_on_net_open_timeout
    stub(Net::HTTP).get_response.with_any_args { raise Net::OpenTimeout }
    assert_raises(Net::OpenTimeout) do
      mktmpdir do |path|
        Workspace.prepare_in_dir(:dummy, "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", nil, path, trace_writer: trace_writer)
      end
    end
    assert_equal 4, trace_writer.writer.count {|trace| trace[:message] == 'Retrying download...'}
  end

  def test_prepare_from_dir
    mktmpdir do |path|
      archive_path = Pathname(__dir__) + "data"
      Workspace.prepare_in_dir(:dummy, archive_path.to_s, nil, path, trace_writer: trace_writer)

      assert (path + "empty.rb").file?
    end
  end

  def test_prepare_from_archive
    mktmpdir do |path|
      archive_path = Pathname(__dir__) + "data/foo.tgz"
      Workspace.prepare_in_dir(:dummy, archive_path.to_s, nil, path, trace_writer: trace_writer)

      assert (path + "querly.gemspec").file?
    end
  end

  def test_prepare_from_encrypted_archive
    mktmpdir do |path|
      # Already the archive encrypted by following command:
      # git archive -o archive.tar.gz -- 58c75ce
      # openssl enc -aes256 -k 'CfAlFi2Uq3aiS3qSnq3Wq0gQWieTbt3151Z+iFXnE3o=' -in archive.tar.gz -out encrypted.tar.gz
      archive_path = Pathname(__dir__) + "data/encrypted.tar.gz"
      Workspace.prepare_in_dir(:dummy, archive_path.to_s, "CfAlFi2Uq3aiS3qSnq3Wq0gQWieTbt3151Z+iFXnE3o=", path, trace_writer: trace_writer)

      assert (path + "querly.gemspec").file?
    end
  end

  def test_prepare_with_base
    mktmpdir do |working_dir|
      Workspace.open(base: (Pathname(__dir__) + "data/encrypted.tar.gz").to_s, base_key: "CfAlFi2Uq3aiS3qSnq3Wq0gQWieTbt3151Z+iFXnE3o=",
                     head: (Pathname(__dir__) + "data/foo.tgz").to_s, head_key: nil,
                     working_dir: working_dir,
                     ssh_key: nil,
                     trace_writer: trace_writer) do |workspace|
        assert (workspace.working_dir + "querly.gemspec").file?
        refute (workspace.working_dir + "foo.tgz").file?

        changes = workspace.calculate_changes

        refute changes.changed_files.empty?
        refute changes.unchanged_paths.empty?
        assert changes.untracked_paths.empty?
      end
    end
  end

  def test_prepare_without_base
    mktmpdir do |working_dir|
      Workspace.open(base: nil, base_key: nil,
                     head: (Pathname(__dir__) + "data/foo.tgz").to_s, head_key: nil,
                     working_dir: working_dir,
                     ssh_key: nil,
                     trace_writer: trace_writer) do |workspace|

        assert (workspace.working_dir + "querly.gemspec").file?
        refute (workspace.working_dir + "foo.tgz").file?

        changes = workspace.calculate_changes

        refute changes.changed_files.empty?
        assert changes.unchanged_paths.empty?
        assert changes.untracked_paths.empty?
      end
    end
  end

  def test_prepare_ssh
    mktmpdir do |working_dir|
      Workspace.open(base: nil, base_key: nil,
                     head: (Pathname(__dir__) + "data/foo.tgz").to_s, head_key: nil,
                     working_dir: working_dir,
                     ssh_key: (Pathname(__dir__) + "data/ssh_key").to_s,
                     trace_writer: trace_writer) do |workspace|

        # Clone private repository using ssh key
        Open3.capture3(
          { "GIT_SSH" => workspace.git_ssh_path.to_s },
          "git", "clone", "--depth=1", "git@github.com:sideci/go_private_library.git",
          { chdir: working_dir.to_s }
        ).tap do |_stdout, stderr, status|
          unless status.success?
            puts stderr
            fail
          end
        end

        assert (workspace.working_dir + "go_private_library/main.go").file?
      end
    end
  end
end
