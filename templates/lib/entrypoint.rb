$LOAD_PATH << __dir__

class Processor < NodeHarness::Processor
  Schema = StrongJSON.new do
    let :runner_config, NodeHarness::Schema::RunnerConfig.base.update_fields { |fields|
      # Define schema in config file
    }
  end

  def self.ci_config_section_name
    # Section name in config file, Generally it is the name of analyzer tool.
  end

  # NodeHarness::Nodejs module concludes what analyzer runs with `nodejs_analyzer_command`.
  # When the method was missing, analyses will raise NotImplementedError.
  # If this runner does not use Nodejs module, delete it.
  # def nodejs_analyzer_command
  #   'analyzer_name' # e.g. eslint, stylelint, tslint and etc.
  # end

  def analyzer
    @analyzer ||= NodeHarness::Analyzer.new(name: "TODO", version: "0.0.0")
  end

  def setup
    # run preprocess for analysis
    yield
  end

  def analyze(changes)
    # run analysis and return result
    ensure_runner_config_schema(Schema.runner_config) do |config|
      # capture3!("foo", "bar" ...)
    end
  end
end

NodeHarness.register_processor Processor
