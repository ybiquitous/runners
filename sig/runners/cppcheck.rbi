type NodeHarness::Runners::Cppcheck::config = {
  target: String | Array<String> | nil,
  ignore: String | Array<String> | nil,
  enable: String?,
  std: String?,
  project: String?,
  language: String?,
}

class NodeHarness::Runners::Cppcheck::Processor < NodeHarness::Processor
  def cppcheck: -> String
  def config: -> config
  def target: -> Array<String>
  def ignore: -> Array<String>
  def enable: -> Array<String>
  def std: -> Array<String>
  def project: -> Array<String>
  def language: -> Array<String>
  def run_analyzer: -> result
  def parse_result: (String) { (NodeHarness::Issues::Text) -> void } -> void
end

NodeHarness::Runners::Cppcheck::Processor::DEFAULT_TARGET: String
NodeHarness::Runners::Cppcheck::Processor::DEFAULT_IGNORE: Array<String>

class NodeHarness::Runners::Cppcheck::Processor::JSONSchema < StrongJSON
  def runner_config: -> StrongJSON::_Schema<NodeHarness::Runners::Cppcheck::config>
end
NodeHarness::Runners::Cppcheck::Processor::Schema: NodeHarness::Runners::Cppcheck::Processor::JSONSchema
