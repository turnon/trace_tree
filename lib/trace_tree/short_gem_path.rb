require 'trace_tree/gem_paths'

class TraceTree
  module ShortGemPath

    def source_location
      #"#{shorten_gem_path current.file}:#{current.line}"
      "#{shorten_gem_path path}:#{lineno}"
    end

    private

    def shorten_gem_path loc
      return '' if loc.nil?
      GemPaths.each{|name, path| loc = loc.gsub(path, "$#{name}")}
      loc
    end
  end
end
