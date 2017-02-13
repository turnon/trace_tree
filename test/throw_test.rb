require 'test_helper'

class ThrowTest < Minitest::Test

  class Throw
    def a
      catch :out do
        b
        c
      end
      e
    end

    def b
      d
    end

    def c
    end

    def d
      throw :out
    end

    def e
      ReturnValue
    end
  end

  Tracetree = <<EOS
ThrowTest#block in test_trace_tree /home/z/trace_tree/test/throw_test.rb:48
└─ThrowTest::Throw#a /home/z/trace_tree/test/throw_test.rb:6
  ├─ThrowTest::Throw#block in a /home/z/trace_tree/test/throw_test.rb:7
  │ └─ThrowTest::Throw#b /home/z/trace_tree/test/throw_test.rb:14
  │   └─ThrowTest::Throw#d /home/z/trace_tree/test/throw_test.rb:21
  │     └─throw in ThrowTest::Throw#d /home/z/trace_tree/test/throw_test.rb:22
  └─ThrowTest::Throw#e /home/z/trace_tree/test/throw_test.rb:25
EOS

  ReturnValue = '1234567'

  def setup
    @test = Throw.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false) do
      @test.a
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end
end
