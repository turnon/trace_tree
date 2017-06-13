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

    def c
    end

    def d
    end

    def e
      ReturnValue
    end
  end

  Tracetree = <<EOS
NormalTest#block in test_trace_tree /home/z/trace_tree/test/normal_test.rb:45
└─NormalTest::Normal#a /home/z/trace_tree/test/normal_test.rb:7
  ├─NormalTest::Normal#b /home/z/trace_tree/test/normal_test.rb:12
  │ ├─NormalTest::Normal#c /home/z/trace_tree/test/normal_test.rb:17
  │ └─NormalTest::Normal#d /home/z/trace_tree/test/normal_test.rb:20
  └─NormalTest::Normal#e /home/z/trace_tree/test/normal_test.rb:23
EOS

  ReturnValue = '1234567'

  def setup
    @test = Normal.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, ex: Ignore) do
      @test.a
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'normal.html', ex: Ignore) do
      @test.a
    end
    assert_equal ReturnValue, rt
  end

end
