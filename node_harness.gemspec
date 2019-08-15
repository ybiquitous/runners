# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'node_harness/version'

Gem::Specification.new do |spec|
  spec.name          = "node_harness"
  spec.version       = NodeHarness::VERSION
  spec.authors       = ["Soutaro Matsumoto"]
  spec.email         = ["matsumoto@soutaro.com"]

  spec.summary       = %q{SideCI Node2 tooling}
  spec.description   = %q{SideCI Node2 tooling}
  spec.homepage      = "https://github.com/sideci/node_harness"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata = { "steep_types" => "sig" }

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://nothing.example.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.add_runtime_dependency "strong_json", "~> 2.0.0"
  spec.add_runtime_dependency "unification_assertion", "~> 0.0.1"
  spec.add_runtime_dependency "jsonseq", "~> 0.1"
  spec.add_runtime_dependency "activesupport", "~> 5.0"
  spec.add_runtime_dependency "retryable", ">= 2.0.4"
  spec.add_runtime_dependency "parallel", ">= 1.12.1"
  spec.add_runtime_dependency "psych", ">= 3.0.2", '< 4'

  spec.add_development_dependency "bundler", ">= 1.12", "< 3.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "thor", "~> 0.20.0"
  spec.add_development_dependency "rr", "~> 1.2.1"
  spec.add_development_dependency "querly", "~> 0.13"
  spec.add_development_dependency "steep", "~> 0.11"
end
