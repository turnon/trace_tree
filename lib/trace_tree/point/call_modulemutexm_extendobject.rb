require 'mutex_m'

class TraceTree
  class Point
    class CallModuleMutexmExtendobject < Point

      def mixin
        Mutex_m
      end

      def self.event_class_method
        [:call, Mutex_m.singleton_class, :extend_object]
      end

    end
  end
end
