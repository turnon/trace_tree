require "trace_tree/version"
require 'binding_of_callers/pry'
require 'trace_tree/point'
require 'trace_tree/short_gem_path'
require 'trace_tree/color'
require 'trace_tree/tmp_file'
require 'trace_tree/timer'
require 'thread'
require 'terminal-tableofhashes'

class Binding
  def trace_tree *log, **opt, &to_do
    TraceTree.new(self).generate *log, **opt, &to_do
  end
end

class TraceTree

  Events = [:b_call, :b_return,
            :c_call, :c_return,
            :call, :return,
            :class, :end,
            :thread_begin, :thread_end]

  def initialize bi
    @bi = bi
    @trace_points = Queue.new
    @timer = Timer.new
  end

  def generate *log, **opt, &to_do
    @opt = opt
    @log = dump_location *log
    enhance_point **opt
    @build_command = opt[:html] ? :tree_html_full : :tree_graph
    @ignore = opt[:ignore] || {}
    here = bi.eval('self')

    #start_trace
    timer[:trace]
    @tp = TracePoint.new(*Events) do |point|
      trace_points << point_loader.create(point) if wanted? point
    end
    @tp.enable

    here.instance_eval &to_do
  ensure
    #stop_trace
    return unless @tp
    @tp.disable
    timer[:trace]
    dump_trace_tree
  end

  private

  attr_reader :bi, :trace_points, :log, :build_command, :timer, :opt, :point_loader

  def dump_location *log
    return TmpFile.new opt[:tmp] if opt[:tmp]
    log.empty? ? STDOUT : log[0]
  end

  def enhance_point opt
    enhancement = []
    enhancement << TraceTree::Color unless opt[:color] == false
    enhancement << TraceTree::ShortGemPath unless opt[:gem] == false
    @point_loader = Point::Loader.new *enhancement
  end

  def dump_trace_tree
    timer[:tree]
    tree = sort(trace_points_array).send build_command
    timer[:tree]
    log.puts tree
    log.puts timer.to_s if opt[:timer]
  rescue => e
    log.puts timer.to_s
    log.puts e
    log.puts Terminal::Table.from_hashes trace_points_array.map(&:to_h)
  end

  def wanted? trace_point
    @ignore.any? do |attr, pattern|
      pattern =~ trace_point.send(attr)
    end ? false : true
  end

  def sort trace_points
    stacks = Hash.new{|h, thread| h[thread] = []}
    initialized_threads, began_threads = {}, {}

    trace_points.each do |point|
      stack = stacks[point.thread]
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
      initialized_threads[point.return_value] = point if Point::CreturnThreadInitialize.class_of? point
      began_threads[point.thread] = point if Point::Threadbegin.class_of? point
    end

    initialized_threads.each do |thread, point|
      point.thread_begin = began_threads[thread]
    end

    stacks[trace_points.first.thread][0].
      callees[0].
      callees[0]
  end

  def trace_points_array
    return @tpa if defined? @tpa
    @tpa = []
    @tpa << trace_points.deq until trace_points.size == 0
    @tpa
  end

end

