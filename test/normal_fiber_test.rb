require 'test_helper'

class NormalFiberTest < Minitest::Test

  class Normal
    attr_reader :f1, :f2

    def initialize
      @f1 = Fiber.new do
        b
      end

      @f2 = Fiber.new do
        c
        Fiber.yield 1
        c
        Fiber.yield 2
        c
      end
    end

    def b; end
    def c; ReturnValue end

    def test
      f2.resume
      f1.resume
      f2.resume
      f2.resume
    end

    def e
      ReturnValue
    end
  end

  Tracetree = <<EOS
NormalFiberTest#block in test_trace_tree #{__dir__}/normal_fiber_test.rb:62
└─NormalFiberTest::Normal#test #{__dir__}/normal_fiber_test.rb:25
  ├─Fiber#resume #{__dir__}/normal_fiber_test.rb:26
  │ └─NormalFiberTest::Normal#block in initialize #{__dir__}/normal_fiber_test.rb:13
  │   └─NormalFiberTest::Normal#c #{__dir__}/normal_fiber_test.rb:23
  ├─Fiber#resume #{__dir__}/normal_fiber_test.rb:27
  │ └─NormalFiberTest::Normal#block in initialize #{__dir__}/normal_fiber_test.rb:9
  │   └─NormalFiberTest::Normal#b #{__dir__}/normal_fiber_test.rb:22
  ├─Fiber#resume #{__dir__}/normal_fiber_test.rb:28
  │ └─NormalFiberTest::Normal#yield -> block in initialize #{__dir__}/normal_fiber_test.rb:15
  │   └─NormalFiberTest::Normal#c #{__dir__}/normal_fiber_test.rb:23
  └─Fiber#resume #{__dir__}/normal_fiber_test.rb:29
    └─NormalFiberTest::Normal#yield -> block in initialize #{__dir__}/normal_fiber_test.rb:17
      └─NormalFiberTest::Normal#c #{__dir__}/normal_fiber_test.rb:23
EOS

  ReturnValue = '1234567'

  def setup
    @test = Normal.new
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
    rt = binding.trace_tree(html: true, tmp: 'normal_fiber.html', out: Ignore) do
      @test.test
    end
    assert_equal ReturnValue, rt
  end

end
