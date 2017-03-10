class TraceTree
  class Point
    class CcallModulePrepend < Point

      def self.event_class_method
        [:c_call, Module, :prepend]
      end

      def parameters
        callees[0].parameters
      end

    end
  end
end
