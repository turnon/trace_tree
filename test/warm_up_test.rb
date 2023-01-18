require 'test_helper'

class WarmUpTest < Minitest::Test
  class A
    def initialize
      @a = 0
    end

    def a
      @a += 1
    end
  end

  def setup
    @a = A.new
    @first = StringIO.new
    @second = StringIO.new
  end

  def test_warm_up
    rt = binding.trace_tree(@first, color: false, out: Ignore, warm: @a.object_id) do
      @a.a
    end

    assert_equal 1, rt

    @first.rewind
    assert_equal '', @first.read


    rt = binding.trace_tree(@second, color: false, out: Ignore, warm: @a.object_id) do
      @a.a
    end

    assert_equal 2, rt

    @second.rewind
    assert_equal tree_graph, @second.read
  end

  def tree_graph
    if RB_VER < 3.1
<<-EOS
WarmUpTest#block in test_warm_up #{__FILE__}:31
└─WarmUpTest::A#a #{__FILE__}:9
EOS
    else
<<-EOS
WarmUpTest#block in test_warm_up #{__FILE__}:31
└─WarmUpTest::A#a #{__FILE__}:9
  └─Integer#+ #{__FILE__}:10
EOS
    end
  end
end
