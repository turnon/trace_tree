require 'test_helper'

class NormalTest < Minitest::Test

  class Normal

    def a
      b
      e
    end

    def b
      c
      d
    end

    define_method :c do
    end

    def d
    end

    def e
      ReturnValue
    end
  end

  Tracetree = <<EOS
NormalTest#block in test_trace_tree #{__dir__}/normal_test.rb:46
└─NormalTest::Normal#a #{__dir__}/normal_test.rb:7
  ├─NormalTest::Normal#b #{__dir__}/normal_test.rb:12
  │ ├─NormalTest::Normal#c -> block in <class:Normal> /home/z/trace_tree/test/normal_test.rb:17
  │ │ └─NormalTest::Normal#block in <class:Normal> /home/z/trace_tree/test/normal_test.rb:17
  │ └─NormalTest::Normal#d #{__dir__}/normal_test.rb:20
  └─NormalTest::Normal#e #{__dir__}/normal_test.rb:23
EOS

  ReturnValue = '1234567'

  def setup
    @test = Normal.new
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
    rt = binding.trace_tree(html: true, tmp: 'normal.html', out: Ignore) do
      @test.a
    end
    assert_equal ReturnValue, rt
  end

end
