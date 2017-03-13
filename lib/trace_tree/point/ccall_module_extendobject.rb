class TraceTree
  class Point
    class CcallModuleExtendobject < Point

      def mixin
        terminal.mixin
      end

      def self.event_class_method
        [:c_call, Module, :extend_object]
      end

    end
  end
end
