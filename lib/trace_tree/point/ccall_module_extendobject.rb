class TraceTree
  module Point
    class CcallModuleExtendobject

      def mixin
        terminal.mixin
      end

      def self.event_class_method
        [:c_call, Module, :extend_object]
      end

      include Point
    end
  end
end
