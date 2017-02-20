require 'trace_tree/tree_graphable'
require 'trace_tree/tree_htmlable'

class TraceTree
  class Node

    include TreeGraphable
    include TreeHtmlable

    attr_reader :bindings

    def initialize trace_point
      @event = trace_point.event
      @method_id = trace_point.method_id
      @bindings = filter_call_stack trace_point.binding.of_callers
    end

    def << node
      callees << node
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
      bindings.unshift bindings.first if throw_event?
      bindings
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
      "#{event_indicator}#{current.klass}#{current.call_symbol}#{current.frame_env}"
    end

    def source_location
      "#{current.file}:#{current.line}"
    end

    def current
      bindings[0]
    end

    def raise_event?
      @event == :raise
    end

    def throw_event?
      @event == :c_call and :throw == @method_id
    end

    def event_indicator
      return 'raise in ' if raise_event?
      return 'throw in ' if throw_event?
      return ''
    end

  end
end
