require 'trace_tree/tree_graphable'
require 'trace_tree/tree_htmlable'

class TraceTree
  class Point

    include TreeGraphable
    include TreeHtmlable

    attr_reader :current, :thread, :frame_env
    attr_accessor :terminal, :config

    Interfaces = [:event, :defined_class, :method_id, :path, :lineno]
    attr_reader *Interfaces

    class << self
      def inherited base
        bases << base
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
        e, c, m = event_class_method
        point.method_id == m && point.event == e && point.defined_class == c
      end

      def initialize_clone proto
        super.tap do
          instance_variable_set :@proto, proto
        end
      end

      attr_reader :proto

      def cache_event_class_method!
        bases.each do |base|
          base.class_eval <<-EOM
            class << self
              alias_method :_event_class_method, :event_class_method
              def self.event_class_method
                @ecm ||= _event_class_method.freeze
              end
            end
EOM
        end
      end
    end

    def method_missing method_id, *args, &blk
      raise NoMethodError, "NoMethodError: undefined method `#{method_id}' "\
        "for #<#{self.class.proto or self.class.name}#{inspect}>"
    end

    def initialize trace_point
      Interfaces.each do |i|
        instance_variable_set "@#{i}", trace_point.send(i)
      end

      @return_value = trace_point.return_value if x_return?
      @thread = Thread.current

      unless thread?
        there = trace_point.binding.of_caller(3)
        @current = BindingOfCallers::Revealed.new there
        @frame_env = current.frame_env.to_sym
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

    def arguments
      {}.tap do |args|
        if event == :call
          defined_class.instance_method(method_id).parameters.
            each{ |role, name| args[name] = current.lv(name) unless name.nil? && role == :rest }
        end
      end
    end

    def return_value
      x_return? ? @return_value : (terminal.nil? ? nil : terminal.return_value)
    end

    def inspect
      to_h.inspect
    end

    def to_h
      self.class.hashify(self)
    end

    def terminate? point
      (point.defined_class == defined_class && point.method_id == method_id) && (
        (event == :return && point.event == :call) ||
        (event == :b_return && point.event == :b_call) ||
        (event == :c_return && point.event == :c_call) ||
        (event == :end && point.event == :class) ||
        (event == :thread_end && point.event == :thread_begin)
      )
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

      attr_reader :point_classes, :config

      def initialize *enhancement, config
        @config = config
        @bases = Point.bases
        @bases = @bases.map{ |b| b = b.clone; b.prepend *enhancement; b } unless enhancement.empty?
        sort_bases
      end

      def sort_bases
        @methods = {}

        @bases.each do |b|
          event, klass, method = b.event_class_method
          events = (@methods[method] ||= {})
          klasses = (events[event] ||= {})
          klasses[klass] = b
        end

        @common = @methods[nil][:common][nil]
      end

      def create point
        point_klass =
          if events = @methods[point.method_id]
            if klasses = events[point.event]
              klasses[point.defined_class] || @common
            else
              @common
            end
          else
            @common
          end

        poi = point_klass.new point
        poi.config = config
        poi
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

    cache_event_class_method!

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
