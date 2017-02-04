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
      @bindings = after_binding_trace_tree(bindings)
    end

    def parent_of? another
      self.whole_stack == another.whole_stack[1..-1]
    end

    def sibling_of? another
      self.whole_stack[1..-1] == another.whole_stack[1..-1]
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

    def whole_stack
      bindings.map{|b| location b}
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

  end
end
