class TraceTreeTest

  class Test

    attr_reader :stack

    def initialize
      @stack = []
    end

    def a
      @stack << binding.of_callers!
      b
      e
    end

    def b
      @stack << binding.of_callers!
      c
      d
    end

    def c
      @stack << binding.of_callers!
    end

    def d
      @stack << binding.of_callers!
    end

    def e
      @stack << binding.of_callers!
    end
  end
end
