begin
  require 'active_support/concern'

  class TraceTree
    class Point
      class CallActivesupportconcernAppendfeatures < Point

        def self.event_class_method
          [:_call, ActiveSupport::Concern, :append_features]
        end

        def parameters
          current.lv.values.first
        end

      end
    end
  end
rescue LoadError
  nil
end
