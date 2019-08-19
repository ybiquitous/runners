module Cat
  # ModuleInitialize is enabled in recommend config
  def initialize
    p "Now Loading..."
  end

  def multiple_call
    # DuplicateMethodCall is disabled in recommend config
    call
    call
    call
  end

  private

  def call
    p "Meow!"
  end
end

include Cat
multiple_call
