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
      Hash[record.map{|k,v| [k, v[-1] - v[0]]}].to_s
    end

    private

    def ftime time
      time.strftime '%F %T %L'
    end

  end
end
