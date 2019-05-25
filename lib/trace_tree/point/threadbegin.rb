class TraceTree
  class Point
    class Threadbegin < Point

      def self.event_class_method
        [:thread_begin, nil, nil]
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

      def path
        (callee = callees[0]) ? callee.path : nil
      end

      def source_location
        ":#{lineno}"
      end
    end
  end
end
