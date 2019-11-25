require_relative "../test_helper"

class WorkspaceHTTPTest < Minitest::Test
  include TestHelper

  def test_prepare_source
    with_workspace(head: "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      mktmpdir do |dest|
        workspace.send(:prepare_head_source, dest)
        refute_empty dest.children
      end
    end
  end

  def test_prepare_head_source_with_retry_on_cipher_error
    with_workspace(head: "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      stub(workspace).decrypt.with_any_args { raise OpenSSL::Cipher::CipherError }
      stub(workspace).retryable_sleep { 0 }
      assert_raises(OpenSSL::Cipher::CipherError) do
        mktmpdir do |dest|
          workspace.send(:prepare_head_source, dest)
        end
      end
      assert_equal 4, workspace.trace_writer.writer.count { |trace| trace[:message] == 'Retrying download...' }
    end
  end

  def test_prepare_head_source_with_retry_on_download_error
    with_workspace(head: "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      stub(Net::HTTP).get_response.with_any_args.yields(Net::HTTPResponse.new('1.1', 500, 'error'))
      stub(workspace).retryable_sleep { 0 }
      assert_raises(Runners::Workspace::DownloadError) do
        mktmpdir do |dest|
          workspace.send(:prepare_head_source, dest)
        end
      end
      assert_equal 4, workspace.trace_writer.writer.count { |trace| trace[:message] == 'Retrying download...' }
    end
  end

  def test_prepare_head_source_with_retry_on_net_open_timeout
    with_workspace(head: "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      stub(Net::HTTP).get_response.with_any_args { raise Net::OpenTimeout }
      stub(workspace).retryable_sleep { 0 }
      assert_raises(Net::OpenTimeout) do
        mktmpdir do |dest|
          workspace.send(:prepare_head_source, dest)
        end
      end
      assert_equal 4, workspace.trace_writer.writer.count { |trace| trace[:message] == 'Retrying download...' }
    end
  end

  def test_prepare_base_source_raise_if_base_is_nil
    with_workspace(head: "http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/core/os/x86_64/core.db.tar.gz", head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::HTTP, workspace
      mktmpdir do |dest|
        assert_raises do
          workspace.send(:prepare_base_source, dest)
        end
      end
    end
  end
end
