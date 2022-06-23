require 'yaml'

class TraceTree
  GemPaths = {}

  ::Gem.path.each_with_index { |path, i| GemPaths["GemPath#{i}"] = path }
end
