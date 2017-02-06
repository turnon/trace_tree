require 'test_helper'

class BlockTest < Minitest::Test

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

  Tracetree = <<EOS
BlockTest#block in test_trace_tree /home/z/trace_tree/test/block_test.rb:47
└─BlockTest::Block#a /home/z/trace_tree/test/block_test.rb:13
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:14
  │ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:19
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:14
  │ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:19
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:14
  │ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:19
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:15
  │ └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:20
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:15
  │ └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:20
  └─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:15
    └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:20
EOS

  ReturnValue = '1234567'

  def test_trace_tree
    test = Block.new 3
    sio = StringIO.new

    rt = binding.trace_tree(sio) do
      test.a
    end

    assert_equal ReturnValue, rt

    sio.rewind
    assert_equal Tracetree, sio.read
  end
end
