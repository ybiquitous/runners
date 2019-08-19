# Awesome class
class Cat
  def self.call
    self.new.call
    self.new.call
    self.new.call
  end

  def call
    "Meow!"
  end
end

Cat.call
