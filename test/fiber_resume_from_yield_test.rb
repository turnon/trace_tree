require 'test_helper'

class FiberResumeFromYieldTest < Minitest::Test

  class Test
    def initialize
      @n = 0
      @track = []
      @f = Fiber.new do |*args|
        while true
          track
          Fiber.yield @n
        end
      end
    end

    def jump_one
      jump 1
      @f.resume
    end

    def jump_two
      jump 2
      @f.resume
    end

    private

    def jump n
      @n += n
    end

    def track
      @track << @n
    end
  end

  Tracetree = <<EOS
FiberResumeFromYieldTest#block in test_trace_tree #{__dir__}/fiber_resume_from_yield_test.rb:61
├─FiberResumeFromYieldTest::Test#jump_one #{__dir__}/fiber_resume_from_yield_test.rb:17
│ ├─FiberResumeFromYieldTest::Test#jump #{__dir__}/fiber_resume_from_yield_test.rb:29
│ └─Fiber#resume #{__dir__}/fiber_resume_from_yield_test.rb:19
│   ├─#<Class:Fiber>#yield; #{__dir__}/fiber_resume_from_yield_test.rb:12
│   ├─FiberResumeFromYieldTest::Test#track #{__dir__}/fiber_resume_from_yield_test.rb:33
│   └─#<Class:Fiber>#yield ... #{__dir__}/fiber_resume_from_yield_test.rb:12
└─FiberResumeFromYieldTest::Test#jump_two #{__dir__}/fiber_resume_from_yield_test.rb:22
  ├─FiberResumeFromYieldTest::Test#jump #{__dir__}/fiber_resume_from_yield_test.rb:29
  └─Fiber#resume #{__dir__}/fiber_resume_from_yield_test.rb:24
    ├─#<Class:Fiber>#yield; #{__dir__}/fiber_resume_from_yield_test.rb:12
    ├─FiberResumeFromYieldTest::Test#track #{__dir__}/fiber_resume_from_yield_test.rb:33
    └─#<Class:Fiber>#yield ~ #{__dir__}/fiber_resume_from_yield_test.rb:12
EOS

  def setup
    @test = Test.new
    @test.jump_two
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.jump_one
      @test.jump_two
    end

    assert_equal 5, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'fiber_resume_from_yield.html', out: Ignore) do
      @test.jump_one
      @test.jump_two
    end
    assert_equal 5, rt
  end

end
