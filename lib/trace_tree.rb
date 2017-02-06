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
    trace_points = []
    tp = TracePoint.trace(:call, :b_call) do |p|
      trace_points << TraceTree::Node.new(p)
    end
    eval('self').instance_eval &to_do
  ensure
    tp.disable
    _dump_trace_tree log, trace_points
  end

  private

  def _dump_trace_tree log, trace_points
    tree = TraceTree.
      sort(trace_points).
      tree_graph

    log.puts tree
  end
end
