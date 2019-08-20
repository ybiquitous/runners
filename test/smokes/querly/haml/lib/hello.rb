module Haml::Filters::Hello
  include Haml::Filters::Base

  def render(text)
    text.upcase
  end
end
