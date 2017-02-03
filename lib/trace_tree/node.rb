require 'tree_graph'

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
      location bindings[0]
    end

    def children_for_tree_graph
      callees
    end

    attr_reader :bindings
    attr_accessor :parent

    def initialize bindings
      @bindings = bindings
    end

    def parent_of? node
      location(bindings[0]) == location(node.bindings[1]) and
        bindings.count == (node.bindings.count - 1)
    end

    def sibling_of? node
      location(bindings[1]) == location(node.bindings[1]) and
        bindings.count == node.bindings.count
    end

    def << node
      callees << node
      node.parent = self
    end

    def callees
      @callees ||= []
    end

    protected

    def location bi
      bi.inspect.gsub(/#<Binding:\d+\s(.*):\d+>/, '\1')
    end

  end
end
