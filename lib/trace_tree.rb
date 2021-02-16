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
require 'trace_tree/warm'
require 'thread'
require 'terminal-tableofhashes'

class Binding
  def trace_tree *log, **opt, &to_do
    if (key = opt[:warm]) && !TraceTree::Warm.check_and_warm(key)
      return yield
    end

    TraceTree.new(self).generate(*log, **opt, &to_do)
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
    @log = dump_location(*log)
    @debug = debug_location
    enhance_point
    @build_command = (opt[:html] || opt[:htmp]) ? :tree_html_full : :tree_graph
    make_filter
    @__file__, @__line__, there = bi.eval('[__FILE__, __LINE__, self]')

    #start_trace
    timer[:trace]
    @tp = TracePoint.new(*Events, &@deal)
    @tp.enable

    there.instance_eval(&to_do)
  ensure
    #stop_trace
    return unless @tp
    @tp.disable
    timer[:trace]
    dump_trace_tree
  end

  private

  attr_reader :bi, :trace_points, :log, :build_command, :timer, :opt, :point_loader, :config

  def debug_location
    loc = opt[:debug]
    return nil unless loc
    return loc if loc.respond_to? :puts
    TmpFile.new loc, transcode: opt[:transcode]
  end

  def dump_location *log
    return TmpFile.new(opt[:tmp], transcode: opt[:transcode]) if opt[:tmp]
    return TmpFile.new((opt[:htmp] + '.html'), transcode: opt[:transcode]) if opt[:htmp]
    log.empty? ? STDOUT : log[0]
  end

  def enhance_point
    enhancement = []
    enhancement << TraceTree::Color unless opt[:color] == false
    enhancement << TraceTree::ShortGemPath unless opt[:gem] == false
    if opt[:return].nil? || opt[:return] == true
      enhancement << TraceTree::ConsoleReturnValue
    elsif opt[:return] == :lux
      enhancement << TraceTree::LuxuryReturnValue
    end
    enhancement << TraceTree::Args if opt[:args] == true
    @point_loader = Point::Loader.new(*enhancement, config)
  end

  def dump_trace_tree
    timer[:tree]
    tree = sort(trace_points_array).send build_command
    timer[:tree]
    @debug.puts table_of_points if @debug
    log.puts tree
    log.puts timer.to_s if opt[:timer]
  rescue => e
    log.puts timer.to_s, e.inspect, e.backtrace, table_of_points
  end

  def table_of_points
    Terminal::Table.from_hashes trace_points_array.map(&:to_h)
  end

  def make_filter
    stack_filter =
      if (@no_methods = Array(opt[:no_methods])).empty?
        nil
      else
        'return false unless outside_hidden_stack?(point)'
      end

    path_filter = nil

    if stack_filter.nil? && path_filter.nil?
      return @deal = -> point { trace_points << point_loader.create(point) }
    end

    filter_method = <<-EOM
      def wanted? point
        return false if point.end_of_trace?
        #{stack_filter}
        return true if native?(point) || point.thread_relative?
        return true if point.method_defined_by_define_method?
        #{path_filter}
        true
      end
    EOM

    self.singleton_class.class_eval filter_method

    @deal = -> point do
      po = point_loader.create(point)
      trace_points << po if wanted? po
    end
  end

  def outside_hidden_stack? point
    stack = (point.thread[:trace_tree_no_methods_stack] ||= [])
    empty = stack.empty?

    if point.event == :b_call || point.event == :b_return
      return true if empty
      if point.terminate?(stack.last)
        stack.pop
      else
        stack << point
      end
      return false
    end

    if @no_methods.any?{ |pattern| pattern =~ point.method_id }
      if !empty && point.terminate?(stack.last)
        stack.pop
        return stack.empty?
      else
        stack << point
        point << Point::Omitted.new
        return empty
      end
    end

    empty
  end

  def native? point
    MainFile == point.path ||
      (:b_call == point.event && @__file__ == point.path && @__line__ == point.lineno)
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

    stacks.keys.each{ |thread| thread[:trace_tree_no_methods_stack] = nil }

    # binding.pry

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

