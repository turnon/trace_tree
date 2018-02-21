require 'test_helper'

class FiberYieldTest < Minitest::Test

  class Test
    def initialize
      @mm = Fiber.new do |*args|
        args = Fiber.yield args.min
        args.max
      end
    end

    def test
      min = @mm.resume *Samples.shuffle
      max = @mm.resume *Samples.shuffle
      [min, max]
    end
  end

  Samples = [1, 2, 3]

  Tracetree = <<EOS
FiberYieldTest#block in test_trace_tree #{__dir__}/fiber_yield_test.rb:43
└─FiberYieldTest::Test#test #{__dir__}/fiber_yield_test.rb:13
  ├─Array#shuffle #{__dir__}/fiber_yield_test.rb:14
  ├─Fiber#resume #{__dir__}/fiber_yield_test.rb:14
  │ └─FiberYieldTest::Test#block in initialize #{__dir__}/fiber_yield_test.rb:7
  │   ├─Array#min #{__dir__}/fiber_yield_test.rb:8
  │   └─#<Class:Fiber>#yield #{__dir__}/fiber_yield_test.rb:8
  ├─Array#shuffle #{__dir__}/fiber_yield_test.rb:15
  └─Fiber#resume #{__dir__}/fiber_yield_test.rb:15
    ├─#<Class:Fiber>#yield; #{__dir__}/fiber_yield_test.rb:8
    ├─Array#max #{__dir__}/fiber_yield_test.rb:9
    └─FiberYieldTest::Test#block in initialize; #{__dir__}/fiber_yield_test.rb:10
EOS

  def setup
    @test = Test.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.test
    end

    assert_equal [Samples.min, Samples.max], rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'fiber_yield.html', out: Ignore) do
      @test.test
    end
    assert_equal [Samples.min, Samples.max], rt
  end

end
