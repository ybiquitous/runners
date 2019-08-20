require "node_harness/version"

require "bundler"
require "pathname"
require "open3"
require "json"
require "securerandom"
require "tmpdir"
require "uri"
require "net/http"
require "zlib"
require "time"
require "strong_json"
require "yaml"
require "jsonseq"
require "fileutils"
require "set"
require "active_support"
require "active_support/core_ext/hash/deep_merge"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/string/filters"

require "node_harness/location"
require "node_harness/results"
require "node_harness/issues"
require "node_harness/processor"
require "node_harness/harness"
require "node_harness/analyzer"
require "node_harness/trace_writer"
require "node_harness/changes"
require "node_harness/workspace"
require "node_harness/shell"
require "node_harness/ruby"
require "node_harness/ruby/gem_installer"
require "node_harness/ruby/gem_installer/spec"
require "node_harness/ruby/gem_installer/rubygems_source"
require "node_harness/ruby/gem_installer/git_source"
require "node_harness/ruby/lockfile_loader"
require "node_harness/ruby/lockfile_loader/lockfile"
require "node_harness/nodejs"
require "node_harness/nodejs/constraint"
require "node_harness/nodejs/default_dependencies"
require "node_harness/nodejs/dependency"

require "node_harness/schema/trace"
require "node_harness/schema/runner_config"
require "node_harness/schema/result"

require "node_harness/runners/rubocop/processor"
require "node_harness/runners/reek/processor"
require "node_harness/runners/goodcheck/processor"
require "node_harness/runners/code_sniffer/processor"
# TODO: Add more runners

module NodeHarness
  def self.register_processor(processor)
    @processor = processor
  end

  def self.processor
    @processor
  end
end
