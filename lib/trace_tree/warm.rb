require 'set'

class TraceTree
  module Warm

    Warmed = Set.new
    Lock = Mutex.new

    class << self
      def check_and_warm key
        Lock.synchronize do
          warmed = Warmed.include? key
          Warmed << key unless warmed
          warmed
        end
      end
    end

  end
end
