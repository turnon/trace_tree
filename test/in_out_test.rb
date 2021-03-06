require 'test_helper'
require_relative './include_exclude_test.rb'

class InOutTest < IncludeExcludeTest

  Tracetree = <<EOS
InOutTest#block in test_trace_tree #{__dir__}/in_out_test.rb:71
└─IncludeExcludeTest::O#o #{__dir__}/include_exclude/o.rb:6
  ├─IncludeExcludeTest::O#oo -> block in <class:O> #{__dir__}/include_exclude/o.rb:18
  │ └─IncludeExcludeTest::O#block in <class:O> #{__dir__}/include_exclude/o.rb:18
  │   └─Array#push #{__dir__}/include_exclude/o.rb:19
  ├─Integer#times #{__dir__}/include_exclude/o.rb:8
  ├─Enumerable#map #{__dir__}/include_exclude/o.rb:8
  │ └─Enumerator#each #{__dir__}/include_exclude/o.rb:8
  │   └─Integer#times #{__dir__}/include_exclude/o.rb:8
  │     ├─IncludeExcludeTest::O#block in o #{__dir__}/include_exclude/o.rb:8
  │     │ └─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:9
  │     │   └─Thread#initialize #{__dir__}/include_exclude/o.rb:9
  │     │     └─thread_run :0
  │     │       └─IncludeExcludeTest::O#block (2 levels) in o #{__dir__}/include_exclude/o.rb:9
  │     │         ├─Class#new #{__dir__}/include_exclude/o.rb:10
  │     │         │ └─BasicObject#initialize #{__dir__}/include_exclude/o.rb:10
  │     │         ├─IncludeExcludeTest::O#block (3 levels) in o #{__dir__}/include_exclude/o.rb:10
  │     │         ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │     │         │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │     │         │   └─thread_run :0
  │     │         │     └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
  │     │         │       ├─Class#new #{__dir__}/include_exclude/q.rb:5
  │     │         │       │ └─BasicObject#initialize #{__dir__}/include_exclude/q.rb:5
  │     │         │       └─IncludeExcludeTest::Q#block in q #{__dir__}/include_exclude/q.rb:5
  │     │         └─Thread#join #{__dir__}/include_exclude/p.rb:7
  │     └─IncludeExcludeTest::O#block in o #{__dir__}/include_exclude/o.rb:8
  │       └─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:9
  │         └─Thread#initialize #{__dir__}/include_exclude/o.rb:9
  │           └─thread_run :0
  │             └─IncludeExcludeTest::O#block (2 levels) in o #{__dir__}/include_exclude/o.rb:9
  │               ├─Class#new #{__dir__}/include_exclude/o.rb:10
  │               │ └─BasicObject#initialize #{__dir__}/include_exclude/o.rb:10
  │               ├─IncludeExcludeTest::O#block (3 levels) in o #{__dir__}/include_exclude/o.rb:10
  │               ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │               │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │               │   └─thread_run :0
  │               │     └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
  │               │       ├─Class#new #{__dir__}/include_exclude/q.rb:5
  │               │       │ └─BasicObject#initialize #{__dir__}/include_exclude/q.rb:5
  │               │       └─IncludeExcludeTest::Q#block in q #{__dir__}/include_exclude/q.rb:5
  │               └─Thread#join #{__dir__}/include_exclude/p.rb:7
  ├─Array#each #{__dir__}/include_exclude/o.rb:13
  │ ├─Thread#join #{__dir__}/include_exclude/o.rb:13
  │ └─Thread#join #{__dir__}/include_exclude/o.rb:13
  ├─Class#new #{__dir__}/include_exclude/o.rb:14
  │ └─BasicObject#initialize #{__dir__}/include_exclude/o.rb:14
  ├─IncludeExcludeTest::O#block in o #{__dir__}/include_exclude/o.rb:14
  ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │   └─thread_run :0
  │     └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
  │       ├─Class#new #{__dir__}/include_exclude/q.rb:5
  │       │ └─BasicObject#initialize #{__dir__}/include_exclude/q.rb:5
  │       └─IncludeExcludeTest::Q#block in q #{__dir__}/include_exclude/q.rb:5
  └─Thread#join #{__dir__}/include_exclude/p.rb:7
EOS

  def setup
    @sio = StringIO.new
    @in = /include_exclude\/[mnopq]\.rb/
    @out = [Ignore] + [/p\.rb/]
  end

  def test_trace_tree
    skip
    rt = binding.trace_tree(@sio, color: false, in: @in, out: @out) do
      O.new.o
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    skip
    rt = binding.trace_tree(html: true, tmp: 'in_out.html', in: @in, out: @out) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end

  def test_trace_tree_html_full
    skip
    rt = binding.trace_tree(html: true, tmp: 'in_out_full.html', out: Ignore) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end

end
