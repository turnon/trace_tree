require "trace_tree/version"
require 'binding_of_callers'

class TraceTree

  class Node

    attr_reader :bindings

    def initialize bindings
      @bindings = bindings
    end

    def parent_of? node
      location(bindings[0]) == location(node.bindings[1])
    end

    def sibling_of? node
      location(bindings[1]) == location(node.bindings[1])
    end

    protected

    def location bi
      bi.inspect.gsub(/#<Binding:\d+\s(.*):\d+>/, '\1')
    end

  end
end

class Binding
  def trace_tree &b
    tp = TracePoint.trace(:call)do |tp|
      p tp
      #tp.binding.pry
    end
    eval('self').instance_eval &b
  ensure
    tp.disable
  end
end
