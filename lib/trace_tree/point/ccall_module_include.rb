class TraceTree
  class Point
    class CcallModuleInclude < Point

      def self.event_class_method
        [:c_call, Module, :include]
      end

      # first callee should be append_features(), check if it is native or custom
      def parameters
        first_callee = callees[0]
        Module == first_callee.class_name ? first_callee.return_value : first_callee.class_name
      end

    end
  end
end
