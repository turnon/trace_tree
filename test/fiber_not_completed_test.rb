require 'test_helper'

class FiberNotCompletedTest < Minitest::Test

  class Fibonacci

    def initialize count
      @count = count
      @f = Fiber.new do
        last2, last1 = 0, 1
        Fiber.yield last2
        Fiber.yield last1
        while true do
          next_value = last2 + last1
          Fiber.yield next_value
          last2, last1 = last1, next_value
        end
      end
    end

    def result
      @result ||= @count.times.map do
        @f.resume
      end
    end
  end

  Tracetree = <<EOS
FiberNotCompletedTest#block in test_trace_tree #{__dir__}/fiber_not_completed_test.rb:61
└─FiberNotCompletedTest::Fibonacci#result #{__dir__}/fiber_not_completed_test.rb:21
  ├─Integer#times #{__dir__}/fiber_not_completed_test.rb:22
  └─Enumerable#map #{__dir__}/fiber_not_completed_test.rb:22
    └─Enumerator#each #{__dir__}/fiber_not_completed_test.rb:22
      └─Integer#times #{__dir__}/fiber_not_completed_test.rb:22
        ├─FiberNotCompletedTest::Fibonacci#block in result #{__dir__}/fiber_not_completed_test.rb:22
        │ └─Fiber#resume #{__dir__}/fiber_not_completed_test.rb:23
        │   └─FiberNotCompletedTest::Fibonacci#block in initialize #{__dir__}/fiber_not_completed_test.rb:9
        ├─FiberNotCompletedTest::Fibonacci#block in result #{__dir__}/fiber_not_completed_test.rb:22
        │ └─Fiber#resume #{__dir__}/fiber_not_completed_test.rb:23
        │   └─FiberNotCompletedTest::Fibonacci#yield -> block in initialize #{__dir__}/fiber_not_completed_test.rb:11
        ├─FiberNotCompletedTest::Fibonacci#block in result #{__dir__}/fiber_not_completed_test.rb:22
        │ └─Fiber#resume #{__dir__}/fiber_not_completed_test.rb:23
        │   └─FiberNotCompletedTest::Fibonacci#yield -> block in initialize #{__dir__}/fiber_not_completed_test.rb:12
        ├─FiberNotCompletedTest::Fibonacci#block in result #{__dir__}/fiber_not_completed_test.rb:22
        │ └─Fiber#resume #{__dir__}/fiber_not_completed_test.rb:23
        │   └─FiberNotCompletedTest::Fibonacci#yield -> block in initialize #{__dir__}/fiber_not_completed_test.rb:15
        ├─FiberNotCompletedTest::Fibonacci#block in result #{__dir__}/fiber_not_completed_test.rb:22
        │ └─Fiber#resume #{__dir__}/fiber_not_completed_test.rb:23
        │   └─FiberNotCompletedTest::Fibonacci#yield -> block in initialize #{__dir__}/fiber_not_completed_test.rb:15
        └─FiberNotCompletedTest::Fibonacci#block in result #{__dir__}/fiber_not_completed_test.rb:22
          └─Fiber#resume #{__dir__}/fiber_not_completed_test.rb:23
            └─FiberNotCompletedTest::Fibonacci#yield -> block in initialize #{__dir__}/fiber_not_completed_test.rb:15
EOS

  def setup
    @test = Fibonacci.new 6
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.result
    end

    assert_equal [0, 1, 1, 2, 3, 5], rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'fiber_not_completed.html', out: Ignore) do
      @test.result
    end
    assert_equal [0, 1, 1, 2, 3, 5], rt
  end

end
