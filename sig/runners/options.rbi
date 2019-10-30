class Runners::Options
  attr_reader stdout: ::IO
  attr_reader stderr: ::IO
  attr_reader head: String
  attr_reader head_key: String?
  attr_reader base: String?
  attr_reader base_key: String?
  attr_reader outputs: Array<String>
  attr_reader ssh_key: String?

  def initialize: (::IO, ::IO) -> any
  def io: () -> Runners::IO
  def parse_options: () -> Hash<Symbol, any>
end
