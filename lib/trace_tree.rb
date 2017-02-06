require "trace_tree/version"
require 'binding_of_callers/pry'
require 'trace_tree/node'
require 'trace_tree/short_gem_path'
require 'trace_tree/color'

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
  def trace_tree *log, **opt, &to_do
    log = log.empty? ? STDOUT : log[0]
    node_class = optional_node opt

    trace_points = []
    tp = TracePoint.trace(:call, :b_call, :raise) do |point|
      trace_points << node_class.new(point)
    end

    eval('self').instance_eval &to_do
  ensure
    tp.disable
    _dump_trace_tree log, trace_points
  end

  private

  def optional_node opt
    Class.new TraceTree::Node do
      prepend TraceTree::ShortGemPath unless opt[:gem] == false
      prepend TraceTree::Color unless opt[:color] == false
    end
  end

  def _dump_trace_tree log, trace_points
    tree = TraceTree.
      sort(trace_points).
      tree_graph

    log.puts tree
  end
end
