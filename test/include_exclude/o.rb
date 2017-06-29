class IncludeExcludeTest

  ReturnValue = '1234567'

  class O
    def o
      oo
      ts = 2.times.map do
        Thread.new do
          P.new.p {}
        end
      end
      ts.each &:join
      P.new.p {}
      ReturnValue
    end

    define_method :oo do
      [].push 1
    end
  end
end
