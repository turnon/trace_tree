require 'test_helper'

class FiberTraceInNonRootTest < Minitest::Test

  def setup
    @f0 = Fiber.new do
      Fiber.yield 2.to_s
      0.to_s
    end

    @f1 = Fiber.new do
      1.to_s
      @f0.resume
      3.to_s
    end
  end

  Result = "0"

  Tracetree = <<EOS
FiberTraceInNonRootTest#block (2 levels) in test_trace_tree #{__dir__}/fiber_trace_in_non_root_test.rb:40
├─Fiber#resume #{__dir__}/fiber_trace_in_non_root_test.rb:41
│ └─FiberTraceInNonRootTest#block in setup #{__dir__}/fiber_trace_in_non_root_test.rb:11
│   ├─Integer#to_s #{__dir__}/fiber_trace_in_non_root_test.rb:12
│   ├─Fiber#resume #{__dir__}/fiber_trace_in_non_root_test.rb:13
│   │ └─FiberTraceInNonRootTest#block in setup ... #{__dir__}/fiber_trace_in_non_root_test.rb:6
│   │   ├─Integer#to_s #{__dir__}/fiber_trace_in_non_root_test.rb:7
│   │   └─#<Class:Fiber>#yield ... #{__dir__}/fiber_trace_in_non_root_test.rb:7
│   └─Integer#to_s #{__dir__}/fiber_trace_in_non_root_test.rb:14
├─Integer#to_s #{__dir__}/fiber_trace_in_non_root_test.rb:42
└─Fiber#resume #{__dir__}/fiber_trace_in_non_root_test.rb:43
  ├─#<Class:Fiber>#yield; #{__dir__}/fiber_trace_in_non_root_test.rb:7
  ├─Integer#to_s #{__dir__}/fiber_trace_in_non_root_test.rb:8
  └─FiberTraceInNonRootTest#block in setup; #{__dir__}/fiber_trace_in_non_root_test.rb:9
EOS

  def test_trace_tree
    sio = StringIO.new
    rt = Fiber.new do
      binding.trace_tree(sio, color: false, out: Ignore) do
        @f1.resume
        4.to_s
        @f0.resume
      end
    end.resume

    assert_equal Result, rt

    sio.rewind
    assert_equal Tracetree, sio.read
  end

  def test_trace_tree_html
    rt = Fiber.new do
      binding.trace_tree(html: true, tmp: 'fiber_trace_in_non_root.html', out: Ignore) do
        @f1.resume
        4.to_s
        @f0.resume
      end
    end.resume
    assert_equal Result, rt
  end

end
