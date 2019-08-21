class AController
  def search
    begin
      foo.save
    rescue Exception => e
      logger.warn "Unable to foo, will ignore: #{e}"
    end
  end
end
