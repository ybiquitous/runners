type NodeHarness::Processor::Cppcheck::config = {
  target: String | Array<String> | nil,
  ignore: String | Array<String> | nil,
  enable: String?,
  std: String?,
  project: String?,
  language: String?,
}

class NodeHarness::Processor::Cppcheck < NodeHarness::Processor
  def cppcheck: -> String
  def config: -> config
  def target: -> Array<String>
  def ignore: -> Array<String>
  def enable: -> Array<String>
  def std: -> Array<String>
  def project: -> Array<String>
  def language: -> Array<String>
  def run_analyzer: -> result
  def parse_result: (Nokogiri::XML::Document) { (NodeHarness::Issues::Structured) -> void } -> void
end

NodeHarness::Processor::Cppcheck::DEFAULT_TARGET: String
NodeHarness::Processor::Cppcheck::DEFAULT_IGNORE: Array<String>

class NodeHarness::Processor::Cppcheck::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Processor::Cppcheck::config>
  def rule: -> StrongJSON::_Schema<any>
end
NodeHarness::Processor::Cppcheck::Schema: NodeHarness::Processor::Cppcheck::JSONSchema
