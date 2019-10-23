class Gem::Version
  include Comparable

  def self.create: (String | Gem::Version) -> Gem::Version
  def version: -> String
end
