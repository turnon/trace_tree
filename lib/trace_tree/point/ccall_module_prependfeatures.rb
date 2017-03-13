class TraceTree
  class Point
    class CcallModulePrependfeatures < Point

      def self.event_class_method
        [:c_call, Module, :prepend_features]
      end

      def parameters
        terminal.return_value
      end

    end
  end
end
