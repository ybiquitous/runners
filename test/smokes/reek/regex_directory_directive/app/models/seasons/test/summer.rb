# Reek will detect following code.
class Autumn
  def initialize(september)
    @september = september
  end

  def silver_week
    return if @september.nil?
    'Silver week is dead?'
  end
end
