class TraceTree
  class Point
    class CcallModulePrepend < Point

      def self.event_class_method
        [:c_call, Module, :prepend]
      end

      def parameters
        first_callee = callees[0]
        Module == first_callee.class_name ? first_callee.return_value : first_callee.current.klass
      end

    end
  end
end
