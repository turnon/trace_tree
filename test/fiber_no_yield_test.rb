require 'test_helper'

class FiberNoYieldTest < Minitest::Test

  class Test
    def initialize
      @f = Fiber.new do
        b
      end
    end

    def b
      ReturnValue
    end

    def test
      @f.resume
    end
  end

  ReturnValue = 123

  Tracetree = <<EOS
FiberNoYieldTest#block in test_trace_tree #{__dir__}/fiber_no_yield_test.rb:37
└─FiberNoYieldTest::Test#test #{__dir__}/fiber_no_yield_test.rb:16
  └─Fiber#resume #{__dir__}/fiber_no_yield_test.rb:17
    └─FiberNoYieldTest::Test#block in initialize #{__dir__}/fiber_no_yield_test.rb:7
      └─FiberNoYieldTest::Test#b #{__dir__}/fiber_no_yield_test.rb:12
EOS

  def setup
    @test = Test.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.test
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'fiber_no_yield.html', out: Ignore) do
      @test.test
    end
    assert_equal ReturnValue, rt
  end

end
