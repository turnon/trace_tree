class TraceTree
  class Point
    class CcallThreadInitialize < Point

      def self.event_class_method
        [:c_call, Thread, :initialize]
      end

    end
  end
end
