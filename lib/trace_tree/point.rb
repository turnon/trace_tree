require 'trace_tree/tree_graphable'
require 'trace_tree/tree_htmlable'

class TraceTree
  module Point

    include TreeGraphable
    include TreeHtmlable

    attr_reader :current, :return_value
    attr_accessor :terminal

    Interfaces = [:event, :defined_class, :method_id, :path, :lineno]
    attr_reader *Interfaces

    class << self
      def save trace_point
        point_klass = bases[[trace_point.event, trace_point.defined_class, trace_point.method_id]] || Common
        point_klass.new trace_point
      end

      def included base
        bases[base.event_class_method] = base
      end

      def bases
        @bases ||= {}
      end
    end

    def initialize trace_point
      Interfaces.each do |i|
        instance_variable_set "@#{i}", trace_point.send(i)
      end
      @return_value = trace_point.return_value if x_return?
      @current = trace_point.binding.of_callers[3]
    end

    def c_call?
      event == :c_call
    end

    def x_return?
      event =~ /return/
    end

    def return_value
      raise RuntimeError.new('RuntimeError: not supported by this event') unless x_return?
      @return_value
    end

    def inspect
      attrs = Interfaces.each_with_object({}) do |attr, hash|
        hash[attr] = self.send attr
      end
      attrs.merge!({return_value: self.return_value}) if x_return?
      attrs.inspect
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
        (event == :end and point.event == :class)
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

  end
end

Dir.glob(File.expand_path('../point/*', __FILE__)).each do |concreate_point_path|
  load concreate_point_path
end
