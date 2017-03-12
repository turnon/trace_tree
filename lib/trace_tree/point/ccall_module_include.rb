class TraceTree
  class Point
    class CcallModuleInclude < Point

      def self.event_class_method
        [:c_call, Module, :include]
      end

      def parameters
        callees[0].parameters
      end

    end
  end
end
