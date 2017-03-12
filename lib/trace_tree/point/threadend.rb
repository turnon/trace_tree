class TraceTree
  class Point
    class Threadend < Point

      def self.event_class_method
        [:thread_end, nil, nil]
      end

    end
  end
end
