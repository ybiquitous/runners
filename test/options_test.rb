require_relative 'test_helper'

class OptionsTest < Minitest::Test
  include TestHelper

  def test_options_full_source
    with_runners_options_env(source: {
      head: 'http://example.com/head',
      head_key: 'head_key',
      base: 'http://example.com/base',
      base_key: 'base_key',
    }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'http://example.com/head', options.head
      assert_equal 'head_key', options.head_key
      assert_equal 'http://example.com/base', options.base
      assert_equal 'base_key', options.base_key
    end
  end

  def test_options_head_only
    with_runners_options_env(source: {
      head: 'http://example.com/head',
      head_key: 'head_key',
    }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'http://example.com/head', options.head
      assert_equal 'head_key', options.head_key
      assert_nil options.base
      assert_nil options.base_key
    end
  end

  def test_options_head_only_without_key
    with_runners_options_env(source: {
      head: 'http://example.com/head',
    }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'http://example.com/head', options.head
      assert_nil options.head_key
      assert_nil options.base
      assert_nil options.base_key
    end
  end

  def test_options_full_source_without_base_key
    with_runners_options_env(source: {
      head: 'http://example.com/head',
      head_key: 'head_key',
      base: 'http://example.com/base',
    }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'http://example.com/head', options.head
      assert_equal 'head_key', options.head_key
      assert_equal 'http://example.com/base', options.base
      assert_nil options.base_key
    end
  end

  def test_options_full_source_without_head_key
    with_runners_options_env(source: {
      head: 'http://example.com/head',
      base: 'http://example.com/base',
      base_key: 'base_key',
    }) do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'http://example.com/head', options.head
      assert_nil options.head_key
      assert_equal 'http://example.com/base', options.base
      assert_equal 'base_key', options.base_key
    end
  end

  def test_options_with_ssh_key
    with_runners_options_env(source: { head: 'http://example.com/head' },
                             ssh_key: 'ssh') do
      options = Runners::Options.new(stdout, stderr)
      assert_equal 'ssh', options.ssh_key
    end
  end

  def test_options_without_ssh_key
    with_runners_options_env(source: { head: 'http://example.com/head' }) do
      options = Runners::Options.new(stdout, stderr)
      assert_nil options.ssh_key
    end
  end

  def test_options_with_outputs
    with_runners_options_env(source: { head: 'http://example.com/head' },
                             outputs: %w[stdout stderr]) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout, stderr], options.io.ios
    end
  end

  def test_options_with_outputs_s3_url
    with_runners_options_env(source: { head: 'http://example.com/head' },
                             outputs: %w[stdout s3://bucket/abc]) do
      s3_mock = Object.new
      stub(s3_mock).write
      stub(s3_mock).flush
      stub(s3_mock).flush!
      mock(Runners::IO::AwsS3).new("s3://bucket/abc") { s3_mock }
      mock.proxy(Runners::IO).new(stdout, s3_mock)

      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout, s3_mock], options.io.ios
    end
  end

  def test_options_without_outputs
    with_runners_options_env(source: { head: 'http://example.com/head' }) do
      options = Runners::Options.new(stdout, stderr)
      assert_instance_of(Runners::IO, options.io)
      assert_equal [stdout], options.io.ios
    end
  end

  def stdout
    @stdout ||= StringIO.new
  end

  def stderr
    @stderr ||= StringIO.new
  end
end
