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
  def trace_tree log=StringIO.new, &b
    stack = []
    tp = TracePoint.trace(:call)do |tp|
      stack << tp.binding.of_callers![1..-1]
    end
    eval('self').instance_eval &b
  ensure
    tp.disable
    _dump_trace_tree log, stack
  end

  private

  def _dump_trace_tree log, stack
    stack.map!{|calling| TraceTree::Node.new calling}
    tree = TraceTree.
      sort(stack).
      tree_graph
    log.write tree
  end
end
