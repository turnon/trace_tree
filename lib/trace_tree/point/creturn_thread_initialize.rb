class TraceTree
  class Point
    class CreturnThreadInitialize < Point

      def self.event_class_method
        [:c_return, Thread, :initialize]
      end

      attr_accessor :thread_begin
    end
  end
end
