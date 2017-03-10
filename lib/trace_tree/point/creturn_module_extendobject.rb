class TraceTree
  module Point
    class CreturnModuleExtendobject

      def initialize trace_point
        super
        @mixin = return_value.singleton_class.ancestors[1]
      end

      attr_reader :mixin

      def self.event_class_method
        [:c_return, Module, :extend_object]
      end

      include Point

    end
  end
end
