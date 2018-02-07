class TraceTree
  class Point
    class CcallKernelRaise < Point

      def self.event_class_method
        [:c_call, Kernel, :raise]
      end

      def parameters
        if (err_creating = callees[0]) && (e = err_creating.return_value)
          (e.message == e.class.name) ? "#<#{e.class}>" : "#<#{e.class}: #{e.message}>"
        else
          "#<RuntimeError>"
        end
      end

    end
  end
end
