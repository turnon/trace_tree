# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trace_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "trace_tree"
  spec.version       = TraceTree::VERSION
  spec.authors       = ["ken"]
  spec.email         = ["block24block@gmail.com"]

  spec.summary       = %q{Print TracePoint(:b_call, :b_return, :c_call, :c_return, :call, :return, :class, :end, :thread_begin, :thread_end) in tree view, to console or html}
  spec.homepage      = "https://github.com/turnon/trace_tree"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "binding_of_callers", "~> 0.2.3"
  spec.add_dependency "tree_graph", "~> 0.2.4"
  spec.add_dependency "tree_html", "~> 0.1.10"

end
