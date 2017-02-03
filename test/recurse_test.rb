#require 'test_helper'

class RecurseTest < Minitest::Test

  class Recurse

    attr_reader :stack

    def initialize level
      @stack = []
      @level = level
    end

    def a level=1
      @stack << binding.of_callers!
      a(level + 1) if level < @level
      b if level == 1
    end

    def b
      @stack << binding.of_callers!
    end

  end

  def setup
    @test = Recurse.new 4
    @test.a
    @stack = @test.stack.map{|e| TraceTree::Node.new e}
    @root = TraceTree.sort @stack
  end

  def test_that_it_has_a_version_number
    refute_nil ::TraceTree::VERSION
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
    tree = <<EOS
RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
├─RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
│ └─RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
│  └─RecurseTest::Recurse#a /home/z/trace_tree/test/recurse_test.rb
└─RecurseTest::Recurse#b /home/z/trace_tree/test/recurse_test.rb
EOS
    assert_equal tree.chomp, @root.tree_graph
  end
end
