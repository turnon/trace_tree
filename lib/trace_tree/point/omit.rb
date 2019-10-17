class TraceTree
  class Point
    class Omitted < Point

      def initialize
      end

      def class_and_method
        ' - -'
      end

      def source_location
        '-'
      end

      def self.event_class_method
        :omitted
      end

    end
  end
end
