require_relative "../test_helper"

class WorkspaceFileTest < Minitest::Test
  include TestHelper

  def test_prepare_head_source_for_dir
    with_workspace(head: (Pathname(__dir__) + "../data").to_s, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::File, workspace
      mktmpdir do |dest|
        workspace.send(:prepare_head_source, dest)
        assert (dest / "empty.rb").file?
      end
    end
  end

  def test_prepare_head_source_for_archive
    with_workspace(head: (Pathname(__dir__) + "../data/foo.tgz").to_s, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::File, workspace
      mktmpdir do |dest|
        workspace.send(:prepare_head_source, dest)
        assert (dest / "querly.gemspec").file?
      end
    end
  end

  def test_prepare_head_source_for_encrypted_archive
    with_workspace(head: (Pathname(__dir__) + "../data/encrypted.tar.gz").to_s, head_key: "CfAlFi2Uq3aiS3qSnq3Wq0gQWieTbt3151Z+iFXnE3o=",
                   base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::File, workspace
      mktmpdir do |dest|
        workspace.send(:prepare_head_source, dest)
        assert (dest / "querly.gemspec").file?
      end
    end
  end

  def test_prepare_base_source_raise_if_base_is_nil
    with_workspace(head: (Pathname(__dir__) + "../data").to_s, head_key: nil, base: nil, base_key: nil) do |workspace|
      assert_instance_of Runners::Workspace::File, workspace
      mktmpdir do |dest|
        assert_raises do
          workspace.send(:prepare_base_source, dest)
        end
      end
    end
  end
end
