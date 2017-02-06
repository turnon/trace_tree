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
      "#{class_and_method} #{source_location}"
    end

    def children_for_tree_graph
      callees
    end

    attr_reader :bindings
    attr_accessor :parent

    def initialize trace_point
      @event = trace_point.event
      @bindings = filter_call_stack trace_point.binding.of_callers!
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
      range = (raise_event? ? bindings : bindings[1..-1])
      range.map{|b| location_without_lineno b}
    end

    private

    def location_without_lineno bi
      [bi.klass, bi.call_symbol, bi.frame_env, bi.file]
    end

    def filter_call_stack bindings
      bindings = bindings[2..-1]
      bindings = callees_of_binding_trace_tree bindings
      bindings = bindings.reject{|b| b.frame_env =~ /^rescue\sin\s/}
    end

    def callees_of_binding_trace_tree bindings
      bs = []
      bindings.each do |b|
        break if "#{b.klass}#{b.call_symbol}#{b.frame_env}" == "Binding#trace_tree"
        bs << b
      end
      bs
    end

    def class_and_method
      "#{raise_event? ? 'raise in ' : ''}#{current.klass}#{current.call_symbol}#{current.frame_env}"
    end

    def source_location
      "#{shorten_gem_path current.file}:#{current.line}"
    end

    def current
      bindings[0]
    end

    def raise_event?
      @event == :raise
    end

    def shorten_gem_path loc
      GemPaths.each{|name, path| loc = loc.gsub(path, "$#{name}")}
      loc
    end

  end
end
