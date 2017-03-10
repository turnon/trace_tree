class TraceTree
  module Point
    class CcallKernelExtend
      def parameters
        callees[0].mixin
      end

      def self.event_class_method
        [:c_call, Kernel, :extend]
      end

      include Point
    end
  end
end
