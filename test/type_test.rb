require 'test_helper'

class TypeTest < Minitest::Test

  ReturnValue = '1234567'

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
      ReturnValue
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
    rescue => e
      [].push 1
    end
  end

  class F
    include M
    include N
    def f
      raise
    rescue => e
      G.new.g
    end
  end

  class G
    include M
    def g
      raise
    end
  end

  Tracetree = <<EOS
TypeTest#block in setup /home/z/trace_tree/test/type_test.rb:98
└─TypeTest::C#c /home/z/trace_tree/test/type_test.rb:15
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:16
  │ └─#<Class:Thread>#new /home/z/trace_tree/test/type_test.rb:17
  │   └─Thread#initialize /home/z/trace_tree/test/type_test.rb:17
  │     └─thread_run :0
  │       └─TypeTest::C#block (2 levels) in c /home/z/trace_tree/test/type_test.rb:17
  │         └─TypeTest::E#e /home/z/trace_tree/test/type_test.rb:37
  │           ├─Kernel#raise /home/z/trace_tree/test/type_test.rb:48
  │           └─TypeTest::G#g /home/z/trace_tree/test/type_test.rb:56
  │             └─Kernel#raise /home/z/trace_tree/test/type_test.rb:57
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:16
  │ └─#<Class:Thread>#new /home/z/trace_tree/test/type_test.rb:17
  │   └─Thread#initialize /home/z/trace_tree/test/type_test.rb:17
  │     └─thread_run :0
  │       └─TypeTest::C#block (2 levels) in c /home/z/trace_tree/test/type_test.rb:17
  │         └─TypeTest::E#e /home/z/trace_tree/test/type_test.rb:37
  │           ├─Kernel#raise /home/z/trace_tree/test/type_test.rb:48
  │           └─TypeTest::G#g /home/z/trace_tree/test/type_test.rb:56
  │             └─Kernel#raise /home/z/trace_tree/test/type_test.rb:57
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:21
  │ └─Thread#join /home/z/trace_tree/test/type_test.rb:21
  ├─TypeTest::C#block in c /home/z/trace_tree/test/type_test.rb:21
  │ └─Thread#join /home/z/trace_tree/test/type_test.rb:21
  └─TypeTest::E#e /home/z/trace_tree/test/type_test.rb:37
    ├─Kernel#raise /home/z/trace_tree/test/type_test.rb:48
    └─TypeTest::G#g /home/z/trace_tree/test/type_test.rb:56
      └─Kernel#raise /home/z/trace_tree/test/type_test.rb:57
EOS


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
