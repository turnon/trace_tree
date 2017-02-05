require 'test_helper'

class BlockTest < Minitest::Test

  Tree = <<EOS
BlockTest::Block#a /home/z/trace_tree/test/block_test.rb:31
├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:32
│ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:37
├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:32
│ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:37
├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:32
│ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:37
├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:33
│ └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:38
├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:33
│ └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:38
└─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:33
  └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:38
EOS

  ReturnValue = '1234567'

  class Block

    attr_reader :stack

    def initialize n
      @n = n
    end

    def a
      @n.times{b}
      @n.times{c}
      ReturnValue
    end

    def b;end
    def c;end

  end

  def test_trace_tree
    test = Block.new 3
    sio = StringIO.new

    rt = binding.trace_tree(sio) do
      test.a
    end

    assert_equal ReturnValue, rt

    sio.rewind
    assert_equal Tree, sio.read
  end
end
