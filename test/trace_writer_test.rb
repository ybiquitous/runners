require "test_helper"

class TraceWriterTest < Minitest::Test
  TraceWriter = Runners::TraceWriter

  def writer
    @writer ||= TraceWriter.new(writer: [])
  end

  def now
    Time.utc(2017,8,1)
  end

  def test_each_slice
    slices = []
    writer.instance_eval do
      each_slice("1234567890", size: 3) do |text|
        slices << text
      end
    end

    assert_equal ["123\\", "456\\", "789\\", "0"], slices
  end

  def test_stdout
    writer.stdout("hogehoge hugahuga", max_length: 10, recorded_at: now)

    assert_equal [{ trace: 'stdout', string: "hogehoge h\\", recorded_at: now.utc.iso8601 },
                  { trace: 'stdout', string: "ugahuga", recorded_at: now.utc.iso8601 }], writer.writer
  end

  def test_stderr
    writer.stderr("hogehoge hugahuga", max_length: 10, recorded_at: now)

    assert_equal [{ trace: 'stderr', string: "hogehoge h\\", recorded_at: now.utc.iso8601 },
                  { trace: 'stderr', string: "ugahuga", recorded_at: now.utc.iso8601 }], writer.writer
  end

  def test_message_with_block
    writer.message("Hello World") do sleep 0.1 end

    assert writer.writer.any? {|trace| trace[:trace] == 'message' && trace[:message] == "Hello World" }
    assert writer.writer.any? {|trace| trace[:trace] == 'message' && trace[:message] =~ /\A    -> 0\.\d{4}s\Z/ }
  end

  def test_message_with_long_content
    writer.message('a'*4000*4)
    assert_equal 4, writer.writer.size
    assert writer.writer.all? {|trace| trace[:trace] == 'message' && (trace[:message] == 'a'*4000 || trace[:message] == 'a'*4000 + '\\')}
  end

  def test_warning
    writer.warning('hogehoge warn', recorded_at: now)
    writer.warning('hogehoge warn2', file: 'path/to/file.rb', recorded_at: now)

    assert_equal [{ trace: 'warning', message: "hogehoge warn", file: nil, recorded_at: now.utc.iso8601 },
                  { trace: 'warning', message: "hogehoge warn2", file: 'path/to/file.rb', recorded_at: now.utc.iso8601 }], writer.writer
  end

  def test_ci_config
    content = {'linter' => {'rubocop' => {'config' => 'myrubocop.yml'}}}
    writer.ci_config(content, recorded_at: now)
    assert_equal [{ trace: 'ci_config', content: content, recorded_at: now.utc.iso8601 }], writer.writer
  end

  def test_error
    writer.error('hoge error', recorded_at: now)
    assert_equal [{ trace: 'error', message: 'hoge error', recorded_at: now.utc.iso8601 }], writer.writer
  end

  def test_format_duration_in_secs
    assert_equal '10.0', writer.send(:format_duration_in_secs, 10.0)
    assert_equal '1.0', writer.send(:format_duration_in_secs, 1.0)
    assert_equal '0.1', writer.send(:format_duration_in_secs, 0.1)
    assert_equal '0.01', writer.send(:format_duration_in_secs, 0.01)
    assert_equal '0.001', writer.send(:format_duration_in_secs, 0.001)
    assert_equal '0.0001', writer.send(:format_duration_in_secs, 0.0001)
    assert_equal '0.0001', writer.send(:format_duration_in_secs, 0.00001)
    assert_equal '0.0001', writer.send(:format_duration_in_secs, 0.000001)
  end
end
