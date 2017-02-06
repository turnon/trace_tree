require 'test_helper'

class BlockTest < Minitest::Test

  class Block

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
└─BlockTest::Block#a /home/z/trace_tree/test/block_test.rb:11
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:12
  │ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:17
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:12
  │ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:17
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:12
  │ └─BlockTest::Block#b /home/z/trace_tree/test/block_test.rb:17
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:13
  │ └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:18
  ├─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:13
  │ └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:18
  └─BlockTest::Block#block in a /home/z/trace_tree/test/block_test.rb:13
    └─BlockTest::Block#c /home/z/trace_tree/test/block_test.rb:18
EOS

  ReturnValue = '1234567'

  def setup
    @test = Block.new 3
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio) do
      @test.a
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end
end
