require 'test_helper'

class FiberTransferTest < Minitest::Test

  class Test

    attr_accessor :result

    def initialize
      @result = []

      @f1 = Fiber.new do |tr|
        n = 0
        while result.size < 6
          result << "1.#{(n += 1)}"
          tr = tr.transfer Fiber.current
        end
      end

      @f2 = Fiber.new do |tr|
        n = 0
        while result.size < 6
          result << "2.#{(n += 1)}"
          tr = tr.transfer Fiber.current
        end
      end
    end

    def add_result n
      result << n
    end

    def test
      result << "#{0.1}"
      @f1.resume @f2
      result << "#{0.2}"
    end
  end

  Result = [0.1, 1.1, 2.1, 1.2, 2.2, 1.3, 0.2]

  Tracetree = <<EOS
EOS

  def setup
    @test = Test.new
    @sio = StringIO.new
  end

  def test_trace_tree
    binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.test
    end

    assert_equal Result, @test.result.map(&:to_f)

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    binding.trace_tree(html: true, tmp: 'fiber_transfer.html', out: Ignore, debug: 'fiber_transfer.txt') do
      @test.test
    end
    assert_equal Result, @test.result.map(&:to_f)
  end

end
