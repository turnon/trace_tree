class TraceTree
  module Point
    class Common
      def self.event_class_method
        :common
      end
      include Point
    end
  end
end
