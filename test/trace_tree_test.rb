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
    @stack = test.stack
  end

  def test_that_it_has_a_version_number
    refute_nil ::TraceTree::VERSION
  end

  def test_a_calls_b
    assert_equal TraceTree::Node.location(@stack[0][0]), TraceTree::Node.location(@stack[1][1])
  end

  def test_b_calls_c_and_d
    assert_equal TraceTree::Node.location(@stack[1][0]), TraceTree::Node.location(@stack[2][1])
    assert_equal TraceTree::Node.location(@stack[1][0]), TraceTree::Node.location(@stack[3][1])
  end

  def test_a_indirectly_calls_c_and_d
    assert_equal TraceTree::Node.location(@stack[0][0]), TraceTree::Node.location(@stack[2][2])
    assert_equal TraceTree::Node.location(@stack[0][0]), TraceTree::Node.location(@stack[3][2])
  end
end
