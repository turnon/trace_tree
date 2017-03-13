class TraceTree
  class Point
    class CcallClassthreadNew < Point

      def self.event_class_method
        [:c_call, Thread.singleton_class, :new]
      end

    end
  end
end
