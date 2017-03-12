class TraceTree
  class Point
    class CcallKernelExtend < Point
      def parameters
        callees[0].mixin
      end

      def self.event_class_method
        [:c_call, Kernel, :extend]
      end

    end
  end
end
