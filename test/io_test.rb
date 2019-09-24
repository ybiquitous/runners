require_relative "test_helper"

class IOTest < Minitest::Test
  include TestHelper

  def test_io
    out1 = StringIO.new
    out2 = StringIO.new

    def out2.finalize!
      self.write('@finalized!')
    end

    io = Runners::IO.new(out1, out2)
    io.write('abc')
    io.flush
    assert_equal 'abc', out1.tap(&:rewind).read
    assert_equal 'abc', out2.tap(&:rewind).read
    io.finalize!
    # NOTE: `dont_allow(out1).finalize!` doesn't work because of RR,
    #        so check only whether `out2#finalize!` was called or not.
    assert_equal 'abc@finalized!', out2.tap(&:rewind).read
  end

  private

  def stdout
    @stdout ||= StringIO.new
  end
end
