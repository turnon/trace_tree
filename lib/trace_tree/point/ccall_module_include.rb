class TraceTree
  module Point
    class CcallModuleInclude

      def initialize trace_point
        super
      end

      def self.event_class_method
        [:c_call, Module, :include]
      end

      include Point

      def parameters
        callees[0].parameters
      end

    end
  end
end
