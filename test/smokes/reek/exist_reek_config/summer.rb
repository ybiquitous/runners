# This is summer class.
class Summer
  def initialize(august)
    @august = august
  end

  def weekend(fri, sat, sun)
    puts fri + sat + sun
  end

  def summer_vacation
    return if @august.nil?
    'La Vacance!'
  end
end
