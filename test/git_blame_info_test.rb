require_relative "test_helper"

class GitBlameInfoTest < Minitest::Test
  include TestHelper

  GitBlameInfo = Runners::GitBlameInfo

  def porcelain_output
    <<-OUTPUT
cb1af575f65f7cc49668b891fb34a5df692d3a0e 13 7 2
author Yutaka Kamei
author-mail <yutaka@sider.review>
author-time 1568862236
author-tz +0900
committer Yutaka Kamei
committer-mail <yutaka@sider.review>
committer-time 1568862236
committer-tz +0900
summary Refactor Processor to use `#delegate`
previous 42d055236db30ce557b4ec4a3cf43a8684014ed4 lib/runners/processor.rb
filename lib/runners/processor.rb
	    delegate :push_dir, :current_dir, :capture3, :capture3!, :capture3_trace, :capture3_with_retry!, to: :shell
cb1af575f65f7cc49668b891fb34a5df692d3a0e 14 8
	    delegate :env_hash, :push_env_hash, to: :shell
    OUTPUT
  end

  def test_parse
    assert_equal(
      [
        GitBlameInfo.new(commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e", original_line: 13, final_line: 7, line_hash: "a5f52a5e0847c750ab9f24cc5ee4e8aa0b6dfc1d"),
        GitBlameInfo.new(commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e", original_line: 14, final_line: 8, line_hash: "df41b0ec11ed05be0baf51c536dae5670aa7aa3b"),
      ], GitBlameInfo.parse(porcelain_output))
  end

  def test_to_h
    info = GitBlameInfo.new(commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e", original_line: 13, final_line: 7, line_hash: "a5f52a5e0847c750ab9f24cc5ee4e8aa0b6dfc1d")
    assert_equal(
      {
        commit: "cb1af575f65f7cc49668b891fb34a5df692d3a0e",
        original_line: 13,
        final_line: 7,
        line_hash: "a5f52a5e0847c750ab9f24cc5ee4e8aa0b6dfc1d",
      },
      info.to_h,
    )
  end
end
