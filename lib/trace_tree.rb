require "trace_tree/version"
require 'binding_of_callers/pry'
require 'trace_tree/point'
require 'trace_tree/short_gem_path'
require 'trace_tree/color'
require 'trace_tree/return_value'
require 'trace_tree/args'
require 'trace_tree/tmp_file'
require 'trace_tree/timer'
require 'trace_tree/config'
require 'thread'
require 'terminal-tableofhashes'

class Binding
  def trace_tree *log, **opt, &to_do
    TraceTree.new(self).generate *log, **opt, &to_do
  end
end

class TraceTree

  MainFile = __FILE__

  Events = [:b_call, :b_return,
            :c_call, :c_return,
            :call, :return,
            :class, :end,
            :thread_begin, :thread_end]

  def initialize bi
    @bi = bi
    @trace_points = Queue.new
    @timer = Timer.new
    @config = Config.load
  end

  def generate *log, **opt, &to_do
    @opt = opt
    @log = dump_location *log
    @debug = TmpFile.new opt[:debug] if opt[:debug]
    enhance_point
    @build_command = (opt[:html] || opt[:htmp]) ? :tree_html_full : :tree_graph
    make_filter
    @__file__, @__line__, there = bi.eval('[__FILE__, __LINE__, self]')

    #start_trace
    timer[:trace]
    @tp = TracePoint.new *Events, &@deal
    @tp.enable

    there.instance_eval &to_do
  ensure
    #stop_trace
    return unless @tp
    @tp.disable
    timer[:trace]
    dump_trace_tree
  end

  private

  attr_reader :bi, :trace_points, :log, :build_command, :timer, :opt, :point_loader, :config

  def dump_location *log
    return TmpFile.new opt[:tmp] if opt[:tmp]
    return TmpFile.new(opt[:htmp] + '.html') if opt[:htmp]
    log.empty? ? STDOUT : log[0]
  end

  def enhance_point
    enhancement = []
    enhancement << TraceTree::Color unless opt[:color] == false
    enhancement << TraceTree::ShortGemPath unless opt[:gem] == false
    enhancement << TraceTree::ReturnValue unless opt[:return] == false
    enhancement << TraceTree::Args if opt[:args] == true
    @point_loader = Point::Loader.new *enhancement, config
  end

  def dump_trace_tree
    timer[:tree]
    tree = sort(trace_points_array).send build_command
    timer[:tree]
    @debug.puts table_of_points if defined? @debug
    log.puts tree
    log.puts timer.to_s if opt[:timer]
  rescue => e
    log.puts timer.to_s, e.inspect, e.backtrace, table_of_points
  end

  def table_of_points
    Terminal::Table.from_hashes trace_points_array.map(&:to_h)
  end

  def make_filter
    if !opt.key?(:in) && !opt.key?(:out)
      return @deal = -> point { trace_points << point_loader.create(point) }
    end
    @in, @out = Array(opt[:in] || //), Array(opt[:out])
    @deal = -> point do
      po = point_loader.create(point)
      trace_points << po if wanted? po
    end
  end

  def wanted? point
    return false if point.end_of_trace?
    return true if native?(point) || point.thread_relative? || point.method_defined_by_define_method?
    @in.any?{ |pattern| pattern =~ point.path } &&
      @out.all?{ |pattern| pattern !~ point.path }
  end

  def native? point
    MainFile == point.path ||
      (:b_call == point.event && @__file__ == point.path && @__line__ == point.lineno)
  end

  def sort trace_points
    stacks = Hash.new{|h, thread| h[thread] = []}
    fiber_stacks = Hash.new{|h, fiber| h[fiber] = []}
    initialized_threads, began_threads = {}, {}

    trace_points.each do |point|
      stack = stacks[point.thread]
      unless stack.empty?
        last_call = stack.last
        if point.return_or_end?
          if point.terminate? last_call
            last_call.terminal = point
            stack.pop
          elsif last_call.method_id == :resume && last_call.event == :c_call
            fiber_stack = fiber_stacks[last_call.self]
            if !fiber_stack.empty? && point.terminate?(fiber_stack.last)
              fiber_stack.pop.terminal = point
            end
            last_call.has_callee point
          end
        else
          last_call.has_callee point
          stack << point
          if point.method_id == :yield && point.event == :c_call
            fiber_stack = []
            until stack.last.method_id == :resume
              yielded_point = stack.pop
              yielded_point.suspended = true
              fiber_stack << yielded_point
            end
            fiber_stacks[stack.last.self].concat(fiber_stack.reverse!)
          end
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

    #binding.pry

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

