require 'test_helper'

class FiberYieldToNonRootTest < Minitest::Test

  class Test

    attr_reader :result

    def initialize
      @result = []

      @f1 = Fiber.new do
        add_result 1.1
        yield_back
        add_result 1.2
        yield_back
        add_result 1.3
      end

      @f2 = Fiber.new do
        add_result 2.1
        resume_f1
        add_result 2.2
      end
    end

    def resume_f1
      @f1.resume
    end

    def yield_back
      Fiber.yield
    end

    def add_result n
      result << n
    end

    def test
      @f2.resume
      resume_f1
    end
  end

  Result = [2.1, 1.1, 2.2, 1.2]

  Tracetree = <<EOS
FiberYieldToNonRootTest#block in test_trace_tree #{__dir__}/fiber_yield_to_non_root_test.rb:75
└─FiberYieldToNonRootTest::Test#test #{__dir__}/fiber_yield_to_non_root_test.rb:39
  ├─Fiber#resume #{__dir__}/fiber_yield_to_non_root_test.rb:40
  │ └─FiberYieldToNonRootTest::Test#block in initialize #{__dir__}/fiber_yield_to_non_root_test.rb:20
  │   ├─FiberYieldToNonRootTest::Test#add_result #{__dir__}/fiber_yield_to_non_root_test.rb:35
  │   ├─FiberYieldToNonRootTest::Test#resume_f1 #{__dir__}/fiber_yield_to_non_root_test.rb:27
  │   │ └─Fiber#resume #{__dir__}/fiber_yield_to_non_root_test.rb:28
  │   │   └─FiberYieldToNonRootTest::Test#block in initialize ~ #{__dir__}/fiber_yield_to_non_root_test.rb:12
  │   │     ├─FiberYieldToNonRootTest::Test#add_result #{__dir__}/fiber_yield_to_non_root_test.rb:35
  │   │     └─FiberYieldToNonRootTest::Test#yield_back ... #{__dir__}/fiber_yield_to_non_root_test.rb:31
  │   │       └─#<Class:Fiber>#yield ... #{__dir__}/fiber_yield_to_non_root_test.rb:32
  │   └─FiberYieldToNonRootTest::Test#add_result #{__dir__}/fiber_yield_to_non_root_test.rb:35
  └─FiberYieldToNonRootTest::Test#resume_f1 #{__dir__}/fiber_yield_to_non_root_test.rb:27
    └─Fiber#resume #{__dir__}/fiber_yield_to_non_root_test.rb:28
      ├─#<Class:Fiber>#yield; #{__dir__}/fiber_yield_to_non_root_test.rb:32
      ├─FiberYieldToNonRootTest::Test#yield_back; #{__dir__}/fiber_yield_to_non_root_test.rb:33
      ├─FiberYieldToNonRootTest::Test#add_result #{__dir__}/fiber_yield_to_non_root_test.rb:35
      └─FiberYieldToNonRootTest::Test#yield_back ~ #{__dir__}/fiber_yield_to_non_root_test.rb:31
        └─#<Class:Fiber>#yield ~ #{__dir__}/fiber_yield_to_non_root_test.rb:32
EOS

  def setup
    @test = Test.new
    @sio = StringIO.new
  end

  def test_trace_tree
    binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.test
    end

    assert_equal Result, @test.result

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    binding.trace_tree(html: true, tmp: 'fiber_yield_to_non_root.html', out: Ignore) do
      @test.test
    end
    assert_equal Result, @test.result
  end

end
