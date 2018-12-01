class TraceTree
  class Point
    class ReturnClasstracetreeExcept < Point

      def self.event_class_method
        [:return, TraceTree.singleton_class, :except]
      end

    end
  end
end
