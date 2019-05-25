require 'trace_tree/gem_paths'

class TraceTree
  module ShortGemPath

    def path
      shorten_gem_path super
    end

    private

    def shorten_gem_path loc
      return '' if loc.nil?
      GemPaths.each{|name, path| loc = loc.gsub(path, "$#{name}")}
      loc
    end
  end
end
