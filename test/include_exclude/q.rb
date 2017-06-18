class IncludeExcludeTest
  class Q
    def q
      yield
      R.new.r {}
    end
  end
end
