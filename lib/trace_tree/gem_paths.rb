require 'yaml'

class TraceTree
  GemPaths = {}

  ::YAML.load(`gem env`)["RubyGems Environment"].
    select{|h| h.has_key?("GEM PATHS")}[0].
    values[0].
    each_with_index do |path, i|
      GemPaths["GemPath#{i}"] = path
    end
end
