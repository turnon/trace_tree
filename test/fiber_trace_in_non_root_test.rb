require 'test_helper'

class FiberTraceInNonRootTest < Minitest::Test

  def setup
    @f0 = Fiber.new do
      Fiber.yield two
      zero
    end

    @f1 = Fiber.new do
      one
      @f0.resume
      three
    end
  end

  Result = 0

  Tracetree = <<EOS
EOS

  def test_trace_tree
    sio = StringIO.new
    rt = Fiber.new do
      binding.trace_tree(sio, color: false, out: Ignore, debug: 'fiber_trace_in_non_root.txt') do
        five
        @f1.resume
        four
        tmp = @f0.resume
        six
        tmp
      end
    end.resume

    assert_equal Result, rt

    sio.rewind
    assert_equal Tracetree, sio.read
  end

  def test_trace_tree_html
    skip
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
