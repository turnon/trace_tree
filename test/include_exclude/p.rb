class IncludeExcludeTest
  class P
    def p
      yield
      Thread.new do
        Q.new.q {}
      end.join
    end
  end
end
