require 'trace_tree/tree_graphable'
require 'trace_tree/tree_htmlable'

class TraceTree
  class Point

    include TreeGraphable
    include TreeHtmlable

    attr_reader :current, :return_value
    attr_accessor :terminal

    Interfaces = [:defined_class, :event, :lineno, :method_id, :path]
    attr_reader *Interfaces

    def initialize trace_point
      Interfaces.each do |i|
        instance_variable_set "@#{i}", trace_point.send(i)
      end
      @return_value = trace_point.return_value if return_event?
      @current = trace_point.binding.of_callers[2]
    end

    def return_event?
      event =~ /return/
    end

    def return_value
      raise RuntimeError.new('RuntimeError: not supported by this event') unless return_event?
      @return_value
    end

    def to_s
      #unless current.lv.empty?
      puts "#{defined_class} #{method_id} #{event} #{path} #{lineno} #{current.frame_env}"
      puts "#{current.lv} #{callees.empty? ? '' : 'c: ' + callees[0].current.klass.to_s}" #if defined_class == method_name
      #end
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

    #def whole_stack
    #  bindings.map{|b| location_without_lineno b}
    #end

    #def parent_stack
    #  range = (raise_event? ? bindings : bindings[1..-1])
    #  range.map{|b| location_without_lineno b}
    #end

    #private

    #def location_without_lineno bi
    #  [bi.klass, bi.call_symbol, bi.frame_env, bi.file]
    #end

    #def filter_call_stack bindings
    #  bindings = bindings[2..-1]
    #  #bindings = callees_of_binding_trace_tree bindings
    #  #bindings = bindings.reject{|b| b.frame_env =~ /^rescue\sin\s/}
    #  #bindings.unshift bindings.first if throw_event?
    #  bindings
    #end

    #def callees_of_binding_trace_tree bindings
    #  bs = []
    #  bindings.each do |b|
    #    break if "#{b.klass}#{b.call_symbol}#{b.frame_env}" == "Binding#trace_tree"
    #    bs << b
    #  end
    #  bs
    #end

    def class_and_method
      "#{_class_and_method}#{mixin}"
    end

    def _class_and_method
      @km ||= "#{class_name}#{current.call_symbol}#{method_name}"
    end

    def class_name
      event == :c_call ? defined_class : current.klass
    end

    def method_name
      event == :c_call ? method_id : current.frame_env
    end

    def source_location
      "#{current.file}:#{current.line}"
    end

    def mixin
      case _class_and_method
      when 'Module.include', 'Module.prepend'
        " #{callees[0].terminal.return_value}"
      when 'Kernel.extend'
        " #{callees[0].terminal.return_value.singleton_class.ancestors[1]}"
      end
    end

    #def current
    #  bindings[0]
    #end

    #def raise_event?
    #  @event == :raise
    #end

    #def throw_event?
    #  event == :c_call and :throw == method_id
    #end

    #def event_indicator
    #  return 'raise in ' if raise_event?
    #  return 'throw in ' if throw_event?
    #  return ''
    #end

  end
end
