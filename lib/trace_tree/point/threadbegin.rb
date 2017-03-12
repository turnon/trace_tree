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

    end
  end
end
