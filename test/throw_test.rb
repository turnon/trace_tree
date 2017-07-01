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
ThrowTest#block in test_trace_tree #{__dir__}/throw_test.rb:49
└─ThrowTest::Throw#a #{__dir__}/throw_test.rb:6
  ├─Kernel#catch #{__dir__}/throw_test.rb:7
  │ └─ThrowTest::Throw#block in a #{__dir__}/throw_test.rb:7
  │   └─ThrowTest::Throw#b #{__dir__}/throw_test.rb:14
  │     └─ThrowTest::Throw#d #{__dir__}/throw_test.rb:21
  │       └─Kernel#throw #{__dir__}/throw_test.rb:22
  └─ThrowTest::Throw#e #{__dir__}/throw_test.rb:25
EOS

  ReturnValue = '1234567'

  def setup
    @test = Throw.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.a
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'throw.html') do
      @test.a
    end
    assert_equal ReturnValue, rt
  end
end
