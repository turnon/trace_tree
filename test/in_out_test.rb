require 'test_helper'
require_relative './include_exclude_test.rb'

class InOutTest < IncludeExcludeTest

  Tracetree = <<EOS
InOutTest#block in test_trace_tree /home/z/trace_tree/test/in_out_test.rb:71
└─IncludeExcludeTest::O#o /home/z/trace_tree/test/include_exclude/o.rb:6
  ├─IncludeExcludeTest::O#oo -> block in <class:O> /home/z/trace_tree/test/include_exclude/o.rb:18
  │ └─IncludeExcludeTest::O#block in <class:O> /home/z/trace_tree/test/include_exclude/o.rb:18
  │   └─Array#push /home/z/trace_tree/test/include_exclude/o.rb:19
  ├─Integer#times /home/z/trace_tree/test/include_exclude/o.rb:8
  ├─Enumerable#map /home/z/trace_tree/test/include_exclude/o.rb:8
  │ └─Enumerator#each /home/z/trace_tree/test/include_exclude/o.rb:8
  │   └─Integer#times /home/z/trace_tree/test/include_exclude/o.rb:8
  │     ├─IncludeExcludeTest::O#block in o /home/z/trace_tree/test/include_exclude/o.rb:8
  │     │ └─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/o.rb:9
  │     │   └─Thread#initialize /home/z/trace_tree/test/include_exclude/o.rb:9
  │     │     └─thread_run :0
  │     │       └─IncludeExcludeTest::O#block (2 levels) in o /home/z/trace_tree/test/include_exclude/o.rb:9
  │     │         ├─Class#new /home/z/trace_tree/test/include_exclude/o.rb:10
  │     │         │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/o.rb:10
  │     │         ├─IncludeExcludeTest::O#block (3 levels) in o /home/z/trace_tree/test/include_exclude/o.rb:10
  │     │         ├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/p.rb:5
  │     │         │ └─Thread#initialize /home/z/trace_tree/test/include_exclude/p.rb:5
  │     │         │   └─thread_run :0
  │     │         │     └─IncludeExcludeTest::Q#q /home/z/trace_tree/test/include_exclude/q.rb:3
  │     │         │       ├─Class#new /home/z/trace_tree/test/include_exclude/q.rb:5
  │     │         │       │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/q.rb:5
  │     │         │       └─IncludeExcludeTest::Q#block in q /home/z/trace_tree/test/include_exclude/q.rb:5
  │     │         └─Thread#join /home/z/trace_tree/test/include_exclude/p.rb:7
  │     └─IncludeExcludeTest::O#block in o /home/z/trace_tree/test/include_exclude/o.rb:8
  │       └─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/o.rb:9
  │         └─Thread#initialize /home/z/trace_tree/test/include_exclude/o.rb:9
  │           └─thread_run :0
  │             └─IncludeExcludeTest::O#block (2 levels) in o /home/z/trace_tree/test/include_exclude/o.rb:9
  │               ├─Class#new /home/z/trace_tree/test/include_exclude/o.rb:10
  │               │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/o.rb:10
  │               ├─IncludeExcludeTest::O#block (3 levels) in o /home/z/trace_tree/test/include_exclude/o.rb:10
  │               ├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/p.rb:5
  │               │ └─Thread#initialize /home/z/trace_tree/test/include_exclude/p.rb:5
  │               │   └─thread_run :0
  │               │     └─IncludeExcludeTest::Q#q /home/z/trace_tree/test/include_exclude/q.rb:3
  │               │       ├─Class#new /home/z/trace_tree/test/include_exclude/q.rb:5
  │               │       │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/q.rb:5
  │               │       └─IncludeExcludeTest::Q#block in q /home/z/trace_tree/test/include_exclude/q.rb:5
  │               └─Thread#join /home/z/trace_tree/test/include_exclude/p.rb:7
  ├─Array#each /home/z/trace_tree/test/include_exclude/o.rb:13
  │ ├─Thread#join /home/z/trace_tree/test/include_exclude/o.rb:13
  │ └─Thread#join /home/z/trace_tree/test/include_exclude/o.rb:13
  ├─Class#new /home/z/trace_tree/test/include_exclude/o.rb:14
  │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/o.rb:14
  ├─IncludeExcludeTest::O#block in o /home/z/trace_tree/test/include_exclude/o.rb:14
  ├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/p.rb:5
  │ └─Thread#initialize /home/z/trace_tree/test/include_exclude/p.rb:5
  │   └─thread_run :0
  │     └─IncludeExcludeTest::Q#q /home/z/trace_tree/test/include_exclude/q.rb:3
  │       ├─Class#new /home/z/trace_tree/test/include_exclude/q.rb:5
  │       │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/q.rb:5
  │       └─IncludeExcludeTest::Q#block in q /home/z/trace_tree/test/include_exclude/q.rb:5
  └─Thread#join /home/z/trace_tree/test/include_exclude/p.rb:7
EOS

  def setup
    @sio = StringIO.new
    @in = /include_exclude\/[mnopq]\.rb/
    @out = [Ignore] + [/p\.rb/]
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, in: @in, out: @out) do
      O.new.o
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'in_out.html', in: @in, out: @out) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end

  def test_trace_tree_html_full
    rt = binding.trace_tree(html: true, tmp: 'in_out_full.html', out: Ignore) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end

end
