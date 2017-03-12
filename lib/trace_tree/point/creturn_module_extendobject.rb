class TraceTree
  class Point
    class CreturnModuleExtendobject < Point

      def initialize trace_point
        super
        @mixin = return_value.singleton_class.ancestors[1]
      end

      attr_reader :mixin

      def self.event_class_method
        [:c_return, Module, :extend_object]
      end

    end
  end
end
