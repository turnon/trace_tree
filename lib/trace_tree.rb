require "trace_tree/version"
require 'binding_of_callers/pry'
require 'trace_tree/point'
require 'trace_tree/short_gem_path'
require 'trace_tree/color'
require 'trace_tree/tmp_file'
require 'trace_tree/timer'

class Binding
  def trace_tree *log, **opt, &to_do
    TraceTree.new(self).generate *log, **opt, &to_do
  end
end

class TraceTree

  def initialize bi
    @bi = bi
    @trace_points = []
    @timer = Timer.new
  end

  def generate *log, **opt, &to_do
    @opt = opt
    @log = dump_location *log
    @node_class = optional_node **opt
    @build_command = opt[:html] ? :tree_html_full : :tree_graph
    @ignore = opt[:ignore] || {}
    start_trace
    bi.eval('self').instance_eval &to_do
  ensure
    stop_trace
  end

  private

  attr_reader :bi, :trace_points, :log, :build_command, :timer, :opt

  def start_trace
    timer[:trace]
    @tp = TracePoint.trace(:b_call, :b_return, :c_call, :c_return, :call, :class, :end, :return) do |point|
      trace_points << @node_class.new(point) if wanted? point
    end
  end

  def stop_trace
    return unless @tp
    @tp.disable
    timer[:trace]
    dump_trace_tree
  end

  def dump_location *log
    return TmpFile.new opt[:tmp] if opt[:tmp]
    log.empty? ? STDOUT : log[0]
  end

  def optional_node opt
    Class.new TraceTree::Point do
      prepend TraceTree::ShortGemPath unless opt[:gem] == false
      prepend TraceTree::Color unless opt[:color] == false
    end
  end

  def dump_trace_tree
    timer[:tree]
    tree = sort(trace_points).send build_command
    timer[:tree]
    log.puts tree
    log.puts timer.to_s if opt[:timer]
  end

  def wanted? trace_point
    @ignore.any? do |attr, pattern|
      pattern =~ trace_point.send(attr)
    end ? false : true
  end

  def sort trace_points
    st = trace_points.each_with_object([]) do |point, stack|
      unless stack.empty?
        if point.terminate? stack.last
          stack.last.terminal = point
          stack.pop
        else
          stack.last << point
          stack << point
        end
      else
        stack << point
      end
    end
    trace_points.each{|p| puts p.to_s}
    st[0].
      callees[0].
      callees[1].
      callees[0]
  end

end

