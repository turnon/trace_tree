class TraceTree
  class Point
    class CcallModuleAppendfeatures < Point

      def self.event_class_method
        [:c_call, Module, :append_features]
      end

      def parameters
        terminal.return_value
      end

    end
  end
end
