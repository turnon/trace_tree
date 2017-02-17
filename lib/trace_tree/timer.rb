class TraceTree
  class Timer

    attr_reader :record

    def initialize
      @record = Hash.new do |h, k|
        h[k] = []
      end
    end

    def [](name)
      record[name] << Time.now
    end

    def to_s
      record.map{|k,v| "#{k}: #{ftime v[0]} ~ #{ftime v[-1]} = #{v[-1] - v[0]}"}
    end

    private

    def ftime time
      time.strftime '%F %T %L'
    end

  end
end
