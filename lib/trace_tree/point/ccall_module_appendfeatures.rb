class TraceTree
  module Point
    class CcallModuleAppendfeatures

      def initialize trace_point
        super
      end

      def self.event_class_method
        [:c_call, Module, :append_features]
      end

      include Point

      def parameters
        terminal.return_value
      end

    end
  end
end
