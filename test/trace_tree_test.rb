require 'test_helper'

class TraceTreeTest < Minitest::Test

  class Test

    attr_reader :stack

    def initialize
      @stack = []
    end

    def a
      @stack << binding.of_callers!
      b
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
  end

  def setup
    test = Test.new
    test.a
    @stack = test.stack.map{|e| TraceTree::Node.new e}
  end

  def test_that_it_has_a_version_number
    refute_nil ::TraceTree::VERSION
  end

  def test_a_calls_b
    assert @stack[0].parent_of? @stack[1]
  end

  def test_b_calls_c_and_d
    assert @stack[1].parent_of? @stack[2]
    assert @stack[1].parent_of? @stack[3]
  end

  def test_c_is_sibling_of_d
    assert @stack[2].sibling_of? @stack[3]
  end
end
