require 'tree_graph'
require 'trace_tree/gem_paths'

class TraceTree
  class Node

    include TreeGraph

    def parent_for_tree_graph
      parent
    end

    def is_last_for_tree_graph
      return true unless parent
      parent.callees.index(self) == (parent.callees.count - 1)
    end

    def label_for_tree_graph
      shorten_gem_path location bindings[0]
    end

    def children_for_tree_graph
      callees
    end

    attr_reader :bindings
    attr_accessor :parent

    def initialize bindings
      @bindings = after_binding_trace_tree(bindings)
    end

    def << node
      callees << node
      node.parent = self
    end

    def callees
      @callees ||= []
    end

    def whole_stack
      bindings.map{|b| location_without_lineno b}
    end

    def parent_stack
      bindings[1..-1].map{|b| location_without_lineno b}
    end

    protected

    def location_without_lineno bi
      bi.inspect.gsub(/#<Binding:\d+\s(.*):\d+>/, '\1')
    end

    def location bi
      bi.inspect.gsub(/#<Binding:\d+\s(.*)>/, '\1')
    end

    private

    def after_binding_trace_tree bindings
      bs = []
      bindings.each do |b|
        break if "#{b.klass}#{b.call_symbol}#{b.frame_env}" == "Binding#trace_tree"
        bs << b
      end
      bs
    end

    def shorten_gem_path loc
      GemPaths.each{|name, path| loc = loc.gsub(path, "$#{name}")}
      loc
    end

  end
end
