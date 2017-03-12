class TraceTree
  class Point
    class CreturnClassthreadNew < Point

      def self.event_class_method
        [:c_return, Thread.singleton_class, :new]
      end

    end
  end
end
