require 'trace_tree/tree_graphable'
require 'trace_tree/tree_htmlable'

class TraceTree
  class Point

    include TreeGraphable
    include TreeHtmlable

    attr_reader :current, :thread
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
        attrs = Interfaces.each_with_object({}) do |attr, hash|
          hash[attr] = point.send attr
        end
        attrs.merge!({return_value: point.return_value}) if point.event =~ /return/
        attrs.merge!({thread: point.thread}) if point.respond_to? :thread
        attrs
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
      @current = trace_point.binding.of_callers[3] unless thread?
      @thread = thread? ? trace_point.self : current.send(:eval, 'Thread.current')
    rescue => e
      puts e
    end

    def c_call?
      event == :c_call
    end

    def x_return?
      event =~ /return/
    end

    def thread?
      event =~ /thread/
    end

    def return_value
      raise RuntimeError.new('RuntimeError: not supported by this event') unless x_return?
      @return_value
    end

    def inspect
      self.class.hashify(self).inspect
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
      c_call? ? method_id : current.frame_env
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

Dir.glob(File.expand_path('../point/*', __FILE__)).each do |concreate_point_path|
  load concreate_point_path
  #puts "---->#{concreate_point_path}"
end
