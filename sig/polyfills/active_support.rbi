extension Class (ActiveSupport)
  def subclasses: -> Array<Class>
end

extension Module (ActiveSupport)
  def delegate: (*(String | Symbol), to: (String | Symbol), ?prefix: (String | Symbol), ?allow_nil: bool) -> void
end

extension Object (ActiveSupport)
  def presence: -> self?
  def present?: -> bool
end

extension Hash (ActiveSupport)
  def symbolize_keys: -> self
end
