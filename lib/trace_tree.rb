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
  def trace_tree log=STDOUT, &to_do
    stack = []
    tp = TracePoint.trace(:call, :b_call) do |tp|
      stack << tp.binding.of_callers![1..-1] # ignore this trace block
    end
    eval('self').instance_eval &to_do
  ensure
    tp.disable
    _dump_trace_tree log, stack[1..-1] # ignore to_do block
  end

  private

  def _dump_trace_tree log, stack
    stack = stack.map do |calling|
      TraceTree::Node.new calling
    end

    tree = TraceTree.
      sort(stack).
      tree_graph

    log.write tree
  end
end
