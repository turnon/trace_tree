require 'test_helper'

class RecurseTest < Minitest::Test

  class Recurse

    attr_reader :stack

    def initialize level, stack=nil
      @stack = stack
      @level = level
    end

    def a level=1;@stack << binding.of_callers! if @stack
      a(level + 1) if level < @level
      b if level == 1
    end

    def b;@stack << binding.of_callers! if @stack
      ReturnValue
    end

  end

  Tracetree = <<EOS
RecurseTest#block in test_trace_tree #{__dir__}/recurse_test.rb:42
└─RecurseTest::Recurse#a #{__dir__}/recurse_test.rb:14
  ├─RecurseTest::Recurse#a #{__dir__}/recurse_test.rb:14
  │ └─RecurseTest::Recurse#a #{__dir__}/recurse_test.rb:14
  │   └─RecurseTest::Recurse#a #{__dir__}/recurse_test.rb:14
  └─RecurseTest::Recurse#b #{__dir__}/recurse_test.rb:19
EOS

  ReturnValue = 'asdfg'

  def setup
    @test = Recurse.new 4
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
    rt = binding.trace_tree(html: true, tmp: 'recurse.html', out: Ignore) do
      @test.a
    end
    assert_equal ReturnValue, rt
  end
end
