require_relative "test_helper"
require "node_harness/testing/smoke"

class TestingSmokeTest < Minitest::Test
  def test_unify_result_success
    smoke = NodeHarness::Testing::Smoke.new([])
    assert smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello',
                              }, {
                                guid: 'test-guid',
                                timestamp: :_,
                                message: 'Hello',
                              }, StringIO.new)
  end

  def test_unify_result_failed
    smoke = NodeHarness::Testing::Smoke.new([])
    refute smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello',
                              }, {
                                guid: 'test-guid',
                                timestamp: '2018-07-19 11:29:39 +0900',
                                message: 'Hello',
                              }, StringIO.new)
  end

  def test_unify_result_success_using_regexp
    smoke = NodeHarness::Testing::Smoke.new([])
    assert smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello, World',
                              }, {
                                guid: 'test-guid',
                                timestamp: :_,
                                message: /Hello/,
                              }, StringIO.new)
  end

  def test_unify_result_failed_using_regexp
    smoke = NodeHarness::Testing::Smoke.new([])
    refute smoke.unify_result({
                                guid: 'test-guid',
                                timestamp: Time.now,
                                message: 'Hello, World',
                              }, {
                                guid: 'test-guid',
                                timestamp: :_,
                                message: /Good/,
                              }, StringIO.new)
  end
end
