# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "test"
  spec.version       = "0.0.1"
  spec.authors       = ["Sider"]
  spec.email         = ["support@sider.review"]

  spec.summary       = %q{test gem}
  spec.description   = %q{test gem}
  spec.homepage      = "https://github.com/sider/test"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rubocop", "0.60.0"
end
