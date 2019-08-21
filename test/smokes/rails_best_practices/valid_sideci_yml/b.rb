class BController
  def search
    begin
      foo
    rescue Exception => e
      logger.warn "Unable to foo, will ignore: #{e}"
    end
  end
end
