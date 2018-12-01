class TraceTree
  class Point
    class CallClasstracetreeExcept < Point

      def self.event_class_method
        [:call, TraceTree.singleton_class, :except]
      end

    end
  end
end
