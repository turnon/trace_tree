require 'test_helper'

class RecurseTest < Minitest::Test

  Tree = <<EOS
RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
├─RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
│ └─RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
│   └─RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
└─RecurseTest::Recurse#b /home/z/trace_tree/test/recurse_test.rb
EOS

  ReturnValue = 'asdfg'

  class Recurse

    attr_reader :stack

    def initialize level, stack=nil
      @stack = stack
      @level = level
    end

    def a level=1
      @stack << binding.of_callers! if @stack
      a(level + 1) if level < @level
      b if level == 1
    end

    def b
      @stack << binding.of_callers! if @stack
      ReturnValue
    end

  end

  def setup
    @test = Recurse.new 4, []
    @test.a
    @stack = @test.stack.map{|e| TraceTree::Node.new e}
    @root = TraceTree.sort @stack
  end

  def test_stack_length
    assert_equal 5, @stack.length
  end

  def test_callees
    assert @stack[0].parent_of? @stack[1]
    assert @stack[1].parent_of? @stack[2]
    assert @stack[2].parent_of? @stack[3]
    assert @stack[0].parent_of? @stack[4]
    assert @stack[0].callees.include? @stack[1]
    assert @stack[0].callees.include? @stack[4]
  end

  def test_sibling
    assert @stack[1].sibling_of? @stack[4]
  end

  def test_bottom_of_stack_is_root
    assert_equal @stack[0], @root
  end

  def test_call_tree
    assert_equal Tree.chomp, @root.tree_graph
  end

  def test_trace_tree
    test = Recurse.new 4
    sio = StringIO.new

    rt = binding.trace_tree(sio) do
      test.a
    end

    assert_equal ReturnValue, rt

    sio.rewind
    assert_equal Tree.chomp, sio.read
  end
end
