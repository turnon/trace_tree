require "trace_tree/version"
require 'binding_of_callers'
require 'trace_tree/node'

class TraceTree

  def self.sort stack
    tr = stack.reduce([]) do |trace, node|
      while true
        if trace.empty?
          break
        elsif trace.last.parent_of? node
          trace.last << node
          break
        elsif trace.last.sibling_of? node
          trace.last.parent << node
          trace.pop
          break
        else
          trace.pop
        end
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
