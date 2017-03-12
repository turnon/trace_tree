class TraceTree
  class Point
    class Threadend < Point

      def self.event_class_method
        [:thread_end, nil, nil]
      end

      def class_name
        ''
      end

      def method_name
        :thread_run
      end

      def call_symbol
        ''
      end
    end
  end
end
