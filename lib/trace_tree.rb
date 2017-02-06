require "trace_tree/version"
require 'binding_of_callers'
require 'trace_tree/node'

class TraceTree

  def self.sort stack
    hash = {}
    stack.each do |call|
      unless hash.empty?
        parent = hash[call.parent_stack]
        parent << call if parent
      end
      hash[call.whole_stack] = call
    end
    stack[0]
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
    _dump_trace_tree log, stack
  end

  private

  def _dump_trace_tree log, stack
    stack = stack.map do |calling|
      TraceTree::Node.new calling
    end

    tree = TraceTree.
      sort(stack).
      tree_graph

    log.puts tree
  end
end
