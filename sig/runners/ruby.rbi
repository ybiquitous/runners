module Runners::Ruby : Processor
  # Install given gems and setup environment variables, and yield the block
  def install_gems: <'x> (Array<GemInstaller::Spec>, ?optionals: Array<GemInstaller::Spec>, constraints: Hash<String, Array<String>>) { (Hash<String, String>) -> 'x } -> 'x
  def default_specs: (Array<GemInstaller::Spec>, Hash<String, Array<String>>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def optional_specs: (Array<GemInstaller::Spec>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def user_specs: (Array<GemInstaller::Spec>, LockfileLoader::Lockfile) -> Array<GemInstaller::Spec>
  def show_ruby_runtime_versions: -> void
  def ruby_analyzer_bin: -> Array<String>
end

type Runners::Ruby::gems_item = {
  "name" => String,
  "version" => String?,
  "source" => String?,
  "git" => git_source?,
}

type Runners::Ruby::git_source = {
  "repo" => String,
  "ref" => String?,
  "branch" => String?,
  "tag" => String?,
}

Runners::Ruby::GemInstaller::DEFAULT_SOURCE: String

class Runners::Ruby::GemInstaller
  attr_reader trace_writer: TraceWriter
  attr_reader gem_home: Pathname
  attr_reader specs: Array<Spec>
  attr_reader shell: Shell
  attr_reader constraints: Hash<String, Array<String>>

  def initialize: (shell: Shell,
                   home: Pathname,
                   ci_config_path_name: String,
                   specs: Array<Spec>,
                   constraints: Hash<String, Array<String>>,
                   trace_writer: TraceWriter) -> void
  def install!: <'x> { (Hash<String, String>) -> 'x } -> 'x

  def gemfile_path: -> Pathname
  def gemfile_content: () -> Array<String>
end

class Runners::Ruby::GemInstaller::Spec
  attr_reader name: String
  attr_reader version: Array<String>
  attr_reader source: RubygemsSource | GitSource

  def initialize: (name: String, version: Array<String>, ?source: RubygemsSource | GitSource) -> any
  def override_by_lockfile: (LockfileLoader::Lockfile) -> self

  def self.from_gems: (Array<gems_item | String>) -> Array<Spec>
  def self.merge: (Array<Spec>, Array<Spec>) -> Array<Spec>
end

class Runners::Ruby::GemInstaller::RubygemsSource
  attr_reader source: String

  def initialize: (String) -> any
  def ==: (any) -> bool
  def to_s: () -> String
end

class Runners::Ruby::GemInstaller::GitSource
  attr_reader repo: String
  attr_reader ref: String?
  attr_reader branch: String?
  attr_reader tag: String?

  def initialize: (repo: String, ?ref: String?, ?branch: String?, ?tag: String?) -> any
  def ==: (any) -> bool
  def to_s: () -> String
end

class Runners::Ruby::LockfileLoader
  attr_reader root_dir: Pathname
  attr_reader shell: Shell

  def initialize: (root_dir: Pathname, shell: Shell) -> any
  def ensure_lockfile: <'x> () { (Lockfile) -> 'x } -> 'x
  def gemfile_path: -> Pathname
  def gemfile_lock_path: -> Pathname
  def generate_lockfile: (Pathname) -> Pathname?
end

class Runners::Ruby::LockfileLoader::Lockfile
  attr_reader specs: Array<any>

  def initialize: (Pathname?) -> any

  def spec_exists?: (String) -> bool
  def locked_version: (String) -> String?
  def satisfied_by?: (String, Hash<String, Array<String>>) -> bool
end

class Runners::Ruby::LockfileLoader::Lockfile::UnsupportedSourceError < StandardError
  attr_reader name: String
  attr_reader source: any

  def initialize: (name: String, source: any) -> any
end

module Runners::Ruby::LockfileParser
  def self.parse: (String) -> Bundler::LockfileParser
end
