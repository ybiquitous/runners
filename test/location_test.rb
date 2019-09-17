require_relative "test_helper"

class LocationTest < Minitest::Test
  Location = Runners::Location

  def test_valid_with_every_attributes
    loc = Location.new(start_line: 1, start_column: 1, end_line: 3, end_column: 2)
    assert loc.valid?
  end

  def test_valid_with_start_line
    loc = Location.new(start_line: 1, start_column: nil, end_line: nil, end_column: nil)
    assert loc.valid?
  end

  def test_valid_with_start_and_end_line
    loc = Location.new(start_line: 1, start_column: nil, end_line: 3, end_column: nil)
    assert loc.valid?
  end

  def test_invalid_location
    refute Location.new(start_line: 1, start_column: nil, end_line: 3, end_column: 1).valid?
    refute Location.new(start_line: 1, start_column: 3, end_line: nil, end_column: nil).valid?
  end

  def test_as_json
    loc = Location.new(start_line: 1, start_column: 1, end_line: 3, end_column: 2)
    assert_equal({ start_line: 1, start_column: 1, end_line: 3, end_column: 2 }, loc.as_json)

    loc = Location.new(start_line: 1, start_column: nil, end_line: 3, end_column: nil)
    assert_equal({ start_line: 1, end_line: 3 }, loc.as_json)
  end

  def test_from_json
    assert_equal Location.new(start_line: 1, start_column: nil, end_line: 3, end_column: nil),
                 Location.from_json({ start_line: 1, end_line: 3 })
  end

  def test_from_json_raises_error_if_invalid
    assert_raises Location::InvalidLocationError do
      Location.from_json({ start_line: 1, end_line: 3, end_column: 2 })
    end
  end
end
