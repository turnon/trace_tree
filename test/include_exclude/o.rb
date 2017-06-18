class IncludeExcludeTest

  ReturnValue = '1234567'

  class O
    def o
      ts = 2.times.map do
        Thread.new do
          P.new.p {}
        end
      end
      ts.each &:join
      P.new.p {}
      ReturnValue
    end
  end
end
