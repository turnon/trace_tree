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
BlockTest#block in test_trace_tree #{__dir__}/block_test.rb:50
└─BlockTest::Block#a #{__dir__}/block_test.rb:11
  ├─Integer#times #{__dir__}/block_test.rb:12
  │ ├─BlockTest::Block#block in a #{__dir__}/block_test.rb:12
  │ │ └─BlockTest::Block#b #{__dir__}/block_test.rb:17
  │ ├─BlockTest::Block#block in a #{__dir__}/block_test.rb:12
  │ │ └─BlockTest::Block#b #{__dir__}/block_test.rb:17
  │ └─BlockTest::Block#block in a #{__dir__}/block_test.rb:12
  │   └─BlockTest::Block#b #{__dir__}/block_test.rb:17
  └─Integer#times #{__dir__}/block_test.rb:13
    ├─BlockTest::Block#block in a #{__dir__}/block_test.rb:13
    │ └─BlockTest::Block#c #{__dir__}/block_test.rb:18
    ├─BlockTest::Block#block in a #{__dir__}/block_test.rb:13
    │ └─BlockTest::Block#c #{__dir__}/block_test.rb:18
    └─BlockTest::Block#block in a #{__dir__}/block_test.rb:13
      └─BlockTest::Block#c #{__dir__}/block_test.rb:18
EOS

  ReturnValue = '1234567'

  def setup
    @test = Block.new 3
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.a
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'block.html', out: Ignore) do
      @test.a
    end
    assert_equal ReturnValue, rt
  end
end
