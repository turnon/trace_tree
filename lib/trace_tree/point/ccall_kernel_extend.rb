class TraceTree
  class Point
    class CcallKernelExtend < Point
      def parameters
        first_callee = callees[0]
        first_callee.respond_to?(:mixin) ? first_callee.mixin : first_callee.current.klass
      end

      def self.event_class_method
        [:c_call, Kernel, :extend]
      end

    end
  end
end
