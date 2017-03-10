class TraceTree
  class Point
    class CreturnModuleAppendfeatures < Point

      def self.event_class_method
        [:c_return, Module, :append_features]
      end

    end
  end
end
