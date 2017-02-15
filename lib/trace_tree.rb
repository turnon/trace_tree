require "trace_tree/version"
require 'binding_of_callers/pry'
require 'trace_tree/node'
require 'trace_tree/short_gem_path'
require 'trace_tree/color'

class Binding
  def trace_tree *log, **opt, &to_do
    TraceTree.new(self).generate *log, **opt, &to_do
  end
end

class TraceTree

  def initialize bi
    @bi = bi
    @trace_points = []
  end

  def generate *log, **opt, &to_do
    @log = log.empty? ? STDOUT : log[0]
    node_class = optional_node opt

    tp = TracePoint.trace(:call, :b_call, :raise, :c_call) do |point|
      trace_points << node_class.new(point) if wanted? point
    end

    bi.eval('self').instance_eval &to_do
  ensure
    tp.disable
    dump_trace_tree
  end

  private

  attr_reader :bi, :trace_points, :log

  def optional_node opt
    Class.new TraceTree::Node do
      prepend TraceTree::ShortGemPath unless opt[:gem] == false
      prepend TraceTree::Color unless opt[:color] == false
    end
  end

  def dump_trace_tree
    tree = sort(trace_points).tree_graph
    log.puts tree
  end

  def wanted? trace_point
    trace_point.event != :c_call or trace_point.method_id == :throw
  end

  def sort stack
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

