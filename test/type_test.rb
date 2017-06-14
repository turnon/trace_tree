require 'test_helper'

class TypeTest < Minitest::Test

  module M
  end

  module N
  end

  class C
    include M
    def c
      threads = 2.times.map do
        Thread.new do
          D.new.d
        end
      end
      threads.each{|t| t.join}
      D.new.d
    end
  end

  class D
    include M
    include N
    def d
      E.new.e
    end
  end

  class E
    include M
    def e
      F.new.f
    end
  end

  class F
    include M
    include N
    def f
      ReturnValue
    end
  end

  Tracetree = <<EOS
TypeTest#block in setup /home/z/trace_tree/test/type_test.rb:76
└─TypeTest::C#c /home/z/trace_tree/test/type_test.rb:13
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:14
  │ └─#<Class:Thread>#new /home/z/trace_tree/test/type_test.rb:15
  │   └─Thread#initialize /home/z/trace_tree/test/type_test.rb:15
  │     └─thread_run :0
  │       └─TypeTest::C#block (2 levels) in c /home/z/trace_tree/test/type_test.rb:15
  │         └─TypeTest::E#e /home/z/trace_tree/test/type_test.rb:34
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:14
  │ └─#<Class:Thread>#new /home/z/trace_tree/test/type_test.rb:15
  │   └─Thread#initialize /home/z/trace_tree/test/type_test.rb:15
  │     └─thread_run :0
  │       └─TypeTest::C#block (2 levels) in c /home/z/trace_tree/test/type_test.rb:15
  │         └─TypeTest::E#e /home/z/trace_tree/test/type_test.rb:34
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:19
  │ └─Thread#join /home/z/trace_tree/test/type_test.rb:19
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:19
  │ └─Thread#join /home/z/trace_tree/test/type_test.rb:19
  └─TypeTest::E#e /home/z/trace_tree/test/type_test.rb:34
EOS

  ReturnValue = '1234567'

  def setup
    @test = C.new
    @sio = StringIO.new
    @ex = Ignore.merge({type: N})
    @in = {type: M}
    @to_do = -> {@test.c}
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, ex: @ex, in: @in, &@to_do)
    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'type.html', in: @in, :ex => @ex, &@to_do)
    assert_equal ReturnValue, rt
  end

end
