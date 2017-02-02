require "trace_tree/version"
require 'binding_of_callers'

class TraceTree

  class Node

    attr_reader :bindings
    attr_accessor :parent

    def initialize bindings
      @bindings = bindings
    end

    def parent_of? node
      location(bindings[0]) == location(node.bindings[1])
    end

    def sibling_of? node
      location(bindings[1]) == location(node.bindings[1])
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

  def self.sort stack
    tr = stack.reduce([]) do |trace, node|
      if trace.empty?
      elsif trace.last.parent_of? node
        trace.last << node
      elsif trace.last.sibling_of? node
        trace.last.parent << node
        trace.pop
      end
      trace << node
      trace
    end
    tr[0]
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
