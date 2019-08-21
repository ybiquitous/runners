class Box
  def initialize
    begin
      foo
    rescue Exception => e
      logger.warn "Unable to foo, will ignore: #{e}"
    end
  end
end
