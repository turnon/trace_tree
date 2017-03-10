class TraceTree
  class Point
    class CreturnModulePrependfeatures < Point

      def self.event_class_method
        [:c_return, Module, :prepend_features]
      end

    end
  end
end
