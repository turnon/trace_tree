require 'test_helper'

class FiberYieldRetInDiffMethodTest < Minitest::Test

  class Test
    def initialize
      @n = 0
      @f = Fiber.new do |*args|
        fiber_yield while true
      end
    end

    def fiber_yield
      Fiber.yield(@n += 1)
    end

    def a
      @f.resume
    end

    def b
      @f.resume
    end

    def c
      @f.resume
    end

    def test
      a
      b
      c
    end
  end

  Tracetree = <<EOS
FiberYieldRetInDiffMethodTest#block in test_trace_tree #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:64
└─FiberYieldRetInDiffMethodTest::Test#test #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:29
  ├─FiberYieldRetInDiffMethodTest::Test#a #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:17
  │ └─Fiber#resume #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:18
  │   └─FiberYieldRetInDiffMethodTest::Test#block in initialize ~ #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:8
  │     └─FiberYieldRetInDiffMethodTest::Test#fiber_yield ... #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:13
  │       └─#<Class:Fiber>#yield ... #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:14
  ├─FiberYieldRetInDiffMethodTest::Test#b #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:21
  │ └─Fiber#resume #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:22
  │   ├─#<Class:Fiber>#yield; #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:14
  │   ├─FiberYieldRetInDiffMethodTest::Test#fiber_yield; #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:15
  │   └─FiberYieldRetInDiffMethodTest::Test#fiber_yield ... #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:13
  │     └─#<Class:Fiber>#yield ... #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:14
  └─FiberYieldRetInDiffMethodTest::Test#c #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:25
    └─Fiber#resume #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:26
      ├─#<Class:Fiber>#yield; #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:14
      ├─FiberYieldRetInDiffMethodTest::Test#fiber_yield; #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:15
      └─FiberYieldRetInDiffMethodTest::Test#fiber_yield ~ #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:13
        └─#<Class:Fiber>#yield ~ #{__dir__}/fiber_yield_ret_in_diff_method_test.rb:14
EOS

  def setup
    @test = Test.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.test
    end

    assert_equal 3, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'fiber_yield_ret_in_diff_method.html', out: Ignore) do
      @test.test
    end
    assert_equal 3, rt
  end

end
