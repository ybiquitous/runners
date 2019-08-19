# Reek will not detect following code.
class Spring
  def initialize(april)
    @april = april
  end

  def golden_week
    return if @april.nil?
    '10 days vacations'
  end
end
