require 'test_helper'

class FiberYieldFromDeepTest < Minitest::Test

  class Min
    def initialize
      @c = Fiber.new do |*args|
        compare *args
      end
    end

    def of *args
      @c.resume *args
    end

    private

    def compare *args
      while true do
        args = Array(args)
        break if args.size != 2
        a, b = args
        if a < b
          args = return_a a
        else
          args = return_b b
        end
      end
    end

    def return_b b
      Fiber.yield b
    end

    def return_a a
      Fiber.yield a
    end
  end

  Tracetree = <<EOS
FiberYieldFromDeepTest#block in test_trace_tree #{__dir__}/fiber_yield_from_deep_test.rb:71
├─FiberYieldFromDeepTest::Min#of #{__dir__}/fiber_yield_from_deep_test.rb:12
│ └─Fiber#resume #{__dir__}/fiber_yield_from_deep_test.rb:13
│   └─FiberYieldFromDeepTest::Min#block in initialize ... #{__dir__}/fiber_yield_from_deep_test.rb:7
│     └─FiberYieldFromDeepTest::Min#compare ... #{__dir__}/fiber_yield_from_deep_test.rb:18
│       ├─Kernel#Array #{__dir__}/fiber_yield_from_deep_test.rb:20
│       └─FiberYieldFromDeepTest::Min#return_a ... #{__dir__}/fiber_yield_from_deep_test.rb:35
│         └─#<Class:Fiber>#yield ... #{__dir__}/fiber_yield_from_deep_test.rb:36
├─FiberYieldFromDeepTest::Min#of #{__dir__}/fiber_yield_from_deep_test.rb:12
│ └─Fiber#resume #{__dir__}/fiber_yield_from_deep_test.rb:13
│   ├─#<Class:Fiber>#yield; #{__dir__}/fiber_yield_from_deep_test.rb:36
│   ├─FiberYieldFromDeepTest::Min#return_a; #{__dir__}/fiber_yield_from_deep_test.rb:37
│   ├─Kernel#Array #{__dir__}/fiber_yield_from_deep_test.rb:20
│   └─FiberYieldFromDeepTest::Min#return_b ... #{__dir__}/fiber_yield_from_deep_test.rb:31
│     └─#<Class:Fiber>#yield ... #{__dir__}/fiber_yield_from_deep_test.rb:32
└─FiberYieldFromDeepTest::Min#of #{__dir__}/fiber_yield_from_deep_test.rb:12
  └─Fiber#resume #{__dir__}/fiber_yield_from_deep_test.rb:13
    ├─#<Class:Fiber>#yield; #{__dir__}/fiber_yield_from_deep_test.rb:32
    ├─FiberYieldFromDeepTest::Min#return_b; #{__dir__}/fiber_yield_from_deep_test.rb:33
    ├─Kernel#Array #{__dir__}/fiber_yield_from_deep_test.rb:20
    ├─FiberYieldFromDeepTest::Min#compare; #{__dir__}/fiber_yield_from_deep_test.rb:29
    └─FiberYieldFromDeepTest::Min#block in initialize; #{__dir__}/fiber_yield_from_deep_test.rb:9
EOS

  def setup
    @min = Min.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @min.of 5, 6
      @min.of 8, 7
      @min.of 3
    end

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'fiber_yield_from_deep.html', out: Ignore) do
      @min.of 5, 6
      @min.of 8, 7
      @min.of 3
    end
  end

end
