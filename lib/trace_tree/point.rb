require 'trace_tree/tree_graphable'
require 'trace_tree/tree_htmlable'

class TraceTree
  class Point

    include TreeGraphable
    include TreeHtmlable

    attr_reader :current, :thread, :frame_env
    attr_accessor :terminal

    Interfaces = [:event, :defined_class, :method_id, :path, :lineno]
    attr_reader *Interfaces

    class << self
      def inherited base
        bases << base
      end

      def classes
        @classes ||= bases.each_with_object(Hash.new{|h| h[:common]}){|c, h| h[c.event_class_method] = c}
      end

      def bases
        @bases ||= []
      end

      def hashify point
        h = {}
        h[:event] = point.event
        h[:defined_class] = point.defined_class
        h[:method_id] = point.method_id
        h[:frame_env] = point.frame_env unless point.thread?
        h[:path] = point.path
        h[:lineno] = point.lineno
        h[:thread] = point.thread
        h[:return_value] = point.return_value if point.event =~ /return/
        h
      end

      def class_of? point
        [point.event, point.defined_class, point.method_id] == event_class_method
      end

      def initialize_clone proto
        super.tap do
          instance_variable_set :@proto, proto
        end
      end

      attr_reader :proto
    end

    def method_missing method_id, *args, &blk
      raise NoMethodError, "NoMethodError: undefined method `#{method_id}' for #<#{self.class.proto or self.class.name}#{inspect}>"
    end

    def initialize trace_point
      Interfaces.each do |i|
        instance_variable_set "@#{i}", trace_point.send(i)
      end

      @return_value = trace_point.return_value if x_return?

      if thread?
        @thread = trace_point.self
      else
        there = trace_point.binding.of_caller(3)
        @current = BindingOfCallers::Revealed.new there
        @frame_env = current.frame_env.to_sym
        @thread = current.send(:eval, 'Thread.current')
      end
    rescue => e
      puts e
    end

    def b_call?
      event == :b_call
    end

    def c_call?
      event == :c_call
    end

    def class?
      event == :class
    end

    def x_return?
      event =~ /return/
    end

    def thread?
      event =~ /thread/
    end

    def end_of_trace?
      MainFile == path && (
        (:c_return == event && :instance_eval == method_id) ||
          (:c_call == event && :disable == method_id)
      )
    end

    def return_value
      raise RuntimeError.new('RuntimeError: not supported by this event') unless x_return?
      @return_value
    end

    def inspect
      to_h.inspect
    end

    def to_h
      self.class.hashify(self)
    end

    def terminate? point
      same_method?(point) and ending?(point)
    end

    def same_method? point
      point.defined_class == defined_class and point.method_id == method_id
    end

    def ending? point
      (event == :b_return and point.event == :b_call) or
        (event == :c_return and point.event == :c_call) or
        (event == :return and point.event == :call) or
        (event == :end and point.event == :class) or
        (event == :thread_end and point.event == :thread_begin)
    end

    def << node
      callees << node
    end

    def callees
      @callees ||= []
    end

    def class_and_method
      "#{_class_and_method}#{arg}"
    end

    def _class_and_method
      @km ||= "#{class_name}#{call_symbol}#{method_name}"
    end

    def class_name
      c_call? ? defined_class : current.klass
    rescue => e
      puts event
    end

    def method_name
      return method_id if c_call?
      return frame_env if b_call? || class?
      (method_id == frame_env) ? method_id : "#{method_id} -> #{frame_env}"
    end

    def call_symbol
      c_call? ? '#' : current.call_symbol
    end

    def source_location
      "#{path}:#{lineno}"
    end

    def arg
      respond_to?(:parameters) ? "(#{parameters})" : nil
    end

    class Loader

      attr_reader :point_classes

      def initialize *enhancement
        return @point_classes = Point.classes if enhancement.empty?
        @point_classes = Point.classes.each_with_object(Point.classes.dup) do |entry, hash|
          hash[entry[0]] = entry[1].clone.prepend *enhancement
        end
      end

      def create point
        point_klass = point_classes[[point.event, point.defined_class, point.method_id]]
        point_klass.new point
      end
    end

  end
end

Dir.glob(File.expand_path('../point/*', __FILE__)).each do |concrete_point_path|
  load concrete_point_path
  #puts "---->#{concrete_point_path}"
end

class TraceTree
  class Point

    NativeThreadCall = [CcallClassthreadNew,
                        CreturnClassthreadNew,
                        CcallThreadInitialize,
                        CreturnThreadInitialize,
                        Threadbegin,
                        Threadend]

    def thread_relative?
      NativeThreadCall.any?{ |k| k.class_of? self } ||
        Thread == defined_class
    end

    def method_defined_by_define_method?
      (event == :call || event == :return) &&
        method_id != frame_env
    end

  end
end
