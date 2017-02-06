require 'test_helper'

class NormalTest < Minitest::Test

  class Normal

    attr_reader :stack

    def initialize stack=nil
      @stack = stack
    end

    def a;@stack << binding.of_callers! if @stack
      b
      e
    end

    def b;@stack << binding.of_callers! if @stack
      c
      d
    end

    def c;@stack << binding.of_callers! if @stack
    end

    def d;@stack << binding.of_callers! if @stack
    end

    def e;@stack << binding.of_callers! if @stack
      ReturnValue
    end
  end

  Tree = <<EOS
NormalTest::Normal#a /home/z/trace_tree/test/normal_test.rb:13
├─NormalTest::Normal#b /home/z/trace_tree/test/normal_test.rb:18
│ ├─NormalTest::Normal#c /home/z/trace_tree/test/normal_test.rb:23
│ └─NormalTest::Normal#d /home/z/trace_tree/test/normal_test.rb:26
└─NormalTest::Normal#e /home/z/trace_tree/test/normal_test.rb:29
EOS

  Tracetree = <<EOS
NormalTest#block in test_trace_tree /home/z/trace_tree/test/normal_test.rb:97
└─NormalTest::Normal#a /home/z/trace_tree/test/normal_test.rb:13
  ├─NormalTest::Normal#b /home/z/trace_tree/test/normal_test.rb:18
  │ ├─NormalTest::Normal#c /home/z/trace_tree/test/normal_test.rb:23
  │ └─NormalTest::Normal#d /home/z/trace_tree/test/normal_test.rb:26
  └─NormalTest::Normal#e /home/z/trace_tree/test/normal_test.rb:29
EOS

  ReturnValue = '1234567'

  def setup
    test = Normal.new []
    test.a
    @stack = test.stack.map{|e| TraceTree::Node.new e}
    @root = TraceTree.sort @stack
  end

  def test_stack_length
    assert_equal 5, @stack.length
  end

  def test_a_calls_b
    assert_equal @stack[0].whole_stack, @stack[1].parent_stack
    assert @stack[0].callees.include? @stack[1]
  end

  def test_a_calls_e
    assert_equal @stack[0].whole_stack, @stack[4].parent_stack
    assert @stack[0].callees.include? @stack[4]
  end

  def test_b_calls_c_and_d
    assert_equal @stack[1].whole_stack, @stack[2].parent_stack
    assert_equal @stack[1].whole_stack, @stack[3].parent_stack
    assert @stack[1].callees.include? @stack[2]
    assert @stack[1].callees.include? @stack[2]
  end

  def test_c_is_sibling_of_d
    assert_equal @stack[2].parent_stack, @stack[3].parent_stack
  end

  def test_a_is_root
    assert_equal @stack[0], @root
  end

  def test_call_tree
    assert_equal Tree.chomp, @root.tree_graph
  end

  def test_trace_tree
    test = Normal.new
    sio = StringIO.new

    rt = binding.trace_tree(sio) do
      test.a
    end

    assert_equal ReturnValue, rt

    sio.rewind
    assert_equal Tracetree, sio.read
  end
end
