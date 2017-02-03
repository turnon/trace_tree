require 'test_helper'

class TraceTreeTest < Minitest::Test

  require 'trace_tree_test/test'

  def setup
    test = Test.new
    test.a
    @stack = test.stack.map{|e| TraceTree::Node.new e}
    @root = TraceTree.sort @stack
  end

  def test_that_it_has_a_version_number
    refute_nil ::TraceTree::VERSION
  end

  def test_stack_length
    assert_equal 5, @stack.length
  end

  def test_a_calls_b
    assert @stack[0].parent_of? @stack[1]
    assert @stack[0].callees.include? @stack[1]
  end

  def test_a_calls_e
    assert @stack[0].parent_of? @stack[4]
    assert @stack[0].callees.include? @stack[4]
  end

  def test_b_calls_c_and_d
    assert @stack[1].parent_of? @stack[2]
    assert @stack[1].parent_of? @stack[3]
    assert @stack[1].callees.include? @stack[2]
    assert @stack[1].callees.include? @stack[2]
  end

  def test_c_is_sibling_of_d
    assert @stack[2].sibling_of? @stack[3]
  end

  def test_a_is_root
    assert_equal @stack[0], @root
  end

  def test_call_tree
    tree = <<EOS
TraceTreeTest::Test#a /home/z/trace_tree/test/trace_tree_test/test.rb
├─TraceTreeTest::Test#b /home/z/trace_tree/test/trace_tree_test/test.rb
│ ├─TraceTreeTest::Test#c /home/z/trace_tree/test/trace_tree_test/test.rb
│ └─TraceTreeTest::Test#d /home/z/trace_tree/test/trace_tree_test/test.rb
└─TraceTreeTest::Test#e /home/z/trace_tree/test/trace_tree_test/test.rb
EOS
    assert_equal tree.chomp, @root.tree_graph
  end
end
