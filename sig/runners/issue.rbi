class Runners::Issue
  attr_reader path: Pathname
  attr_reader location: Runners::Location?
  attr_reader id: String
  attr_reader message: String
  attr_reader links: Array<String>
  attr_reader object: any

  def initialize: (path: Pathname, location: Location?, id: String, message: String,
                   ?links: Array<String>, ?object: any, ?schema: any) -> any
  def as_json: () -> any
end
