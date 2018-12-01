require 'test_helper'

class ExceptTest < Minitest::Test

  class Normal
    def a(n = 3)
      b
      TraceTree.except{ c }
      n > 0 ? a(n - 1) : d
    end

    def b
    end

    def c
    end

    def d
      ReturnValue
    end
  end

  Tracetree = <<EOS
ExceptTest#block in test_trace_tree #{__dir__}/except_test.rb:48
└─ExceptTest::Normal#a #{__dir__}/except_test.rb:6
  ├─ExceptTest::Normal#b #{__dir__}/except_test.rb:12
  ├─TraceTree.except #{Lib}/trace_tree.rb:31
  └─ExceptTest::Normal#a #{__dir__}/except_test.rb:6
    ├─ExceptTest::Normal#b #{__dir__}/except_test.rb:12
    ├─TraceTree.except #{Lib}/trace_tree.rb:31
    └─ExceptTest::Normal#a #{__dir__}/except_test.rb:6
      ├─ExceptTest::Normal#b #{__dir__}/except_test.rb:12
      ├─TraceTree.except #{Lib}/trace_tree.rb:31
      └─ExceptTest::Normal#a #{__dir__}/except_test.rb:6
        ├─ExceptTest::Normal#b #{__dir__}/except_test.rb:12
        ├─TraceTree.except #{Lib}/trace_tree.rb:31
        └─ExceptTest::Normal#d #{__dir__}/except_test.rb:18
EOS

  ReturnValue = '1234567'

  def setup
    @test = Normal.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore, except: true) do
      @test.a
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'except.html', out: Ignore, except: true) do
      @test.a
    end
    assert_equal ReturnValue, rt
  end

end
