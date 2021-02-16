require 'test_helper'
require_relative './include_exclude_test.rb'

class OutTest < IncludeExcludeTest

  Tracetree = <<EOS
OutTest#block in test_trace_tree #{__dir__}/out_test.rb:69
├─Class#new #{__dir__}/out_test.rb:70
│ └─BasicObject#initialize #{__dir__}/out_test.rb:70
├─IncludeExcludeTest::O#oo -> block in <class:O> #{__dir__}/include_exclude/o.rb:18
├─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:9
│ └─Thread#initialize #{__dir__}/include_exclude/o.rb:9
│   └─thread_run :0
│     └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
│       ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
│       │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
│       │   └─thread_run :0
│       │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
│       │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
│       │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
│       │       └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
│       │         ├─IncludeExcludeTest::P#block (2 levels) in p #{__dir__}/include_exclude/p.rb:6
│       │         ├─Class#new #{__dir__}/include_exclude/q.rb:5
│       │         │ └─BasicObject#initialize #{__dir__}/include_exclude/q.rb:5
│       │         └─IncludeExcludeTest::R#r #{__dir__}/include_exclude/r.rb:3
│       │           └─IncludeExcludeTest::Q#block in q #{__dir__}/include_exclude/q.rb:5
│       └─Thread#join #{__dir__}/include_exclude/p.rb:7
├─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:9
│ └─Thread#initialize #{__dir__}/include_exclude/o.rb:9
│   └─thread_run :0
│     └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
│       ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
│       │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
│       │   └─thread_run :0
│       │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
│       │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
│       │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
│       │       └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
│       │         ├─IncludeExcludeTest::P#block (2 levels) in p #{__dir__}/include_exclude/p.rb:6
│       │         ├─Class#new #{__dir__}/include_exclude/q.rb:5
│       │         │ └─BasicObject#initialize #{__dir__}/include_exclude/q.rb:5
│       │         └─IncludeExcludeTest::R#r #{__dir__}/include_exclude/r.rb:3
│       │           └─IncludeExcludeTest::Q#block in q #{__dir__}/include_exclude/q.rb:5
│       └─Thread#join #{__dir__}/include_exclude/p.rb:7
├─Thread#join #{__dir__}/include_exclude/o.rb:13
├─Thread#join #{__dir__}/include_exclude/o.rb:13
└─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
  ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │   └─thread_run :0
  │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
  │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
  │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
  │       └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
  │         ├─IncludeExcludeTest::P#block (2 levels) in p #{__dir__}/include_exclude/p.rb:6
  │         ├─Class#new #{__dir__}/include_exclude/q.rb:5
  │         │ └─BasicObject#initialize #{__dir__}/include_exclude/q.rb:5
  │         └─IncludeExcludeTest::R#r #{__dir__}/include_exclude/r.rb:3
  │           └─IncludeExcludeTest::Q#block in q #{__dir__}/include_exclude/q.rb:5
  └─Thread#join #{__dir__}/include_exclude/p.rb:7
EOS

  def setup
    @sio = StringIO.new
    @out = [Ignore] + [/o\.rb/]
  end

  def test_trace_tree
    skip
    rt = binding.trace_tree(@sio, color: false, out: @out) do
      O.new.o
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    skip
    rt = binding.trace_tree(html: true, tmp: 'out.html', out: @out) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end

end
