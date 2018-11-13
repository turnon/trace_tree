require 'test_helper'

class FiberTransferTest < Minitest::Test

  class Test

    attr_accessor :result

    def initialize
      @result = []

      @fiber1 = Fiber.new do |predecessor|
        add_result 1.1
        Fiber.yield
        add_result 1.2
        predecessor.transfer
        add_result 1.3
      end

      @fiber2 = Fiber.new do
        add_result 2.1
        @fiber1.transfer Fiber.current
        add_result 2.2
      end

      @fiber3 = Fiber.new do
        add_result 3
      @fiber1.transfer
      end
    end

    def add_result n
      result << n
    end

    def test
      add_result 0.1
      @fiber2.resume
      @fiber3.resume
      add_result 0.2
    end
  end

  Result = [0.1, 2.1, 1.1, 3, 1.2, 2.2, 0.2]

  Tracetree = <<EOS
EOS

  def setup
    @test = Test.new
    @sio = StringIO.new
  end

  def test_trace_tree
    skip
    binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.test
    end

    assert_equal Result, @test.result

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    skip
    binding.trace_tree(html: true, tmp: 'fiber_transfer.html', out: Ignore, debug: 'fiber_transfer.txt') do
      @test.test
    end
    assert_equal Result, @test.result
  end

end
