type prepare_type = :base | :head

class Runners::Workspace
  attr_reader options: Options
  attr_reader working_dir: Pathname
  attr_reader trace_writer: TraceWriter

  def initialize: (options: Options, working_dir: Pathname, trace_writer: TraceWriter) -> any
  def open: <'a> () { (Pathname?, Changes) -> 'a } -> 'a
  def prepare_ssh: <'a> () { (Pathname?) -> 'a } -> 'a
  def prepare_in_dir: (prepare_type, String, String?, Pathname) -> void
  def decrypt: <'a> (Pathname, String?) { (Pathname) -> 'a } -> 'a
  def decrypt_by_openssl: (Pathname, String, Pathname) -> void
  def extract: (Pathname, Pathname) -> void
  def download: <'a> (URI) { (any) -> 'a } -> 'a
  def retryable_sleep: (Integer) -> Integer
end
