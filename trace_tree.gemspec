# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trace_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "trace_tree"
  spec.version       = TraceTree::VERSION
  spec.authors       = ["ken"]
  spec.email         = ["block24block@gmail.com"]

  spec.summary       = %q{print TracePoints in tree graph}
  spec.homepage      = "https://github.com/turnon/trace_tree"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "binding_of_callers", "0.1.2"
  spec.add_dependency "tree_graph", "~> 0.1.0"
end
