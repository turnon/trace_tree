require 'test_helper'
require_relative './include_exclude_test.rb'

class InTest < IncludeExcludeTest

  Tracetree = <<EOS
InTest#block in test_trace_tree /home/z/trace_tree/test/in_test.rb:55
├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/o.rb:8
│ └─Thread#initialize /home/z/trace_tree/test/include_exclude/o.rb:8
│   └─thread_run :0
│     └─IncludeExcludeTest::P#p /home/z/trace_tree/test/include_exclude/p.rb:3
│       ├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/p.rb:5
│       │ └─Thread#initialize /home/z/trace_tree/test/include_exclude/p.rb:5
│       │   └─thread_run :0
│       │     └─IncludeExcludeTest::P#block in p /home/z/trace_tree/test/include_exclude/p.rb:5
│       │       ├─Class#new /home/z/trace_tree/test/include_exclude/p.rb:6
│       │       │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/p.rb:6
│       │       ├─IncludeExcludeTest::P#block (2 levels) in p /home/z/trace_tree/test/include_exclude/p.rb:6
│       │       └─IncludeExcludeTest::R#r /home/z/trace_tree/test/include_exclude/r.rb:3
│       └─Thread#join /home/z/trace_tree/test/include_exclude/p.rb:7
├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/o.rb:8
│ └─Thread#initialize /home/z/trace_tree/test/include_exclude/o.rb:8
│   └─thread_run :0
│     └─IncludeExcludeTest::P#p /home/z/trace_tree/test/include_exclude/p.rb:3
│       ├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/p.rb:5
│       │ └─Thread#initialize /home/z/trace_tree/test/include_exclude/p.rb:5
│       │   └─thread_run :0
│       │     └─IncludeExcludeTest::P#block in p /home/z/trace_tree/test/include_exclude/p.rb:5
│       │       ├─Class#new /home/z/trace_tree/test/include_exclude/p.rb:6
│       │       │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/p.rb:6
│       │       ├─IncludeExcludeTest::P#block (2 levels) in p /home/z/trace_tree/test/include_exclude/p.rb:6
│       │       └─IncludeExcludeTest::R#r /home/z/trace_tree/test/include_exclude/r.rb:3
│       └─Thread#join /home/z/trace_tree/test/include_exclude/p.rb:7
├─Thread#join /home/z/trace_tree/test/include_exclude/o.rb:12
├─Thread#join /home/z/trace_tree/test/include_exclude/o.rb:12
└─IncludeExcludeTest::P#p /home/z/trace_tree/test/include_exclude/p.rb:3
  ├─#<Class:Thread>#new /home/z/trace_tree/test/include_exclude/p.rb:5
  │ └─Thread#initialize /home/z/trace_tree/test/include_exclude/p.rb:5
  │   └─thread_run :0
  │     └─IncludeExcludeTest::P#block in p /home/z/trace_tree/test/include_exclude/p.rb:5
  │       ├─Class#new /home/z/trace_tree/test/include_exclude/p.rb:6
  │       │ └─BasicObject#initialize /home/z/trace_tree/test/include_exclude/p.rb:6
  │       ├─IncludeExcludeTest::P#block (2 levels) in p /home/z/trace_tree/test/include_exclude/p.rb:6
  │       └─IncludeExcludeTest::R#r /home/z/trace_tree/test/include_exclude/r.rb:3
  └─Thread#join /home/z/trace_tree/test/include_exclude/p.rb:7
EOS

  def setup
    @sio = StringIO.new
    @in = /include_exclude\/[pr]\.rb/
    @out = Ignore
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
    rt = binding.trace_tree(html: true, tmp: 'in.html', in: @in, out: @out) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end

end
