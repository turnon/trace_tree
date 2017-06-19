require 'test_helper'
require_relative './include_exclude_test.rb'

class InTest < IncludeExcludeTest

  Tracetree = <<EOS
InTest#block in test_trace_tree #{__dir__}/in_test.rb:55
├─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:8
│ └─Thread#initialize #{__dir__}/include_exclude/o.rb:8
│   └─thread_run :0
│     └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
│       ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
│       │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
│       │   └─thread_run :0
│       │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
│       │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
│       │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
│       │       ├─IncludeExcludeTest::P#block (2 levels) in p #{__dir__}/include_exclude/p.rb:6
│       │       └─IncludeExcludeTest::R#r #{__dir__}/include_exclude/r.rb:3
│       └─Thread#join #{__dir__}/include_exclude/p.rb:7
├─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:8
│ └─Thread#initialize #{__dir__}/include_exclude/o.rb:8
│   └─thread_run :0
│     └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
│       ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
│       │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
│       │   └─thread_run :0
│       │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
│       │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
│       │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
│       │       ├─IncludeExcludeTest::P#block (2 levels) in p #{__dir__}/include_exclude/p.rb:6
│       │       └─IncludeExcludeTest::R#r #{__dir__}/include_exclude/r.rb:3
│       └─Thread#join #{__dir__}/include_exclude/p.rb:7
├─Thread#join #{__dir__}/include_exclude/o.rb:12
├─Thread#join #{__dir__}/include_exclude/o.rb:12
└─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
  ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │   └─thread_run :0
  │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
  │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
  │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
  │       ├─IncludeExcludeTest::P#block (2 levels) in p #{__dir__}/include_exclude/p.rb:6
  │       └─IncludeExcludeTest::R#r #{__dir__}/include_exclude/r.rb:3
  └─Thread#join #{__dir__}/include_exclude/p.rb:7
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
