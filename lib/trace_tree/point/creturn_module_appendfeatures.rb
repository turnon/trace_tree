class TraceTree
  module Point
    class CreturnModuleAppendfeatures

      def initialize trace_point
        super
      end

      def self.event_class_method
        [:c_return, Module, :append_features]
      end

      include Point

    end
  end
end
