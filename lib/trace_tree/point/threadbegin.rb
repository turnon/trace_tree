class TraceTree
  class Point
    class Threadbegin < Point

      def self.event_class_method
        [:thread_begin, nil, nil]
      end

    end
  end
end
