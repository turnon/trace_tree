require 'test_helper'
require_relative './include_exclude_test.rb'

class NoMethodsTest < IncludeExcludeTest
  Tracetree = <<-EOS
NoMethodsTest#block in test_trace_tree #{__dir__}/no_methods_test.rb:77
├─Class#new #{__dir__}/no_methods_test.rb:78
│ └─BasicObject#initialize #{__dir__}/no_methods_test.rb:78
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
  │     │         └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
  │     │           ├─IncludeExcludeTest::O#block (3 levels) in o #{__dir__}/include_exclude/o.rb:10
  │     │           ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │     │           │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │     │           │   └─thread_run :0
  │     │           │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
  │     │           │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
  │     │           │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
  │     │           │       └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
  │     │           │         └─ - - -
  │     │           └─Thread#join #{__dir__}/include_exclude/p.rb:7
  │     └─IncludeExcludeTest::O#block in o #{__dir__}/include_exclude/o.rb:8
  │       └─#<Class:Thread>#new #{__dir__}/include_exclude/o.rb:9
  │         └─Thread#initialize #{__dir__}/include_exclude/o.rb:9
  │           └─thread_run :0
  │             └─IncludeExcludeTest::O#block (2 levels) in o #{__dir__}/include_exclude/o.rb:9
  │               ├─Class#new #{__dir__}/include_exclude/o.rb:10
  │               │ └─BasicObject#initialize #{__dir__}/include_exclude/o.rb:10
  │               └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
  │                 ├─IncludeExcludeTest::O#block (3 levels) in o #{__dir__}/include_exclude/o.rb:10
  │                 ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
  │                 │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
  │                 │   └─thread_run :0
  │                 │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
  │                 │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
  │                 │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
  │                 │       └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
  │                 │         └─ - - -
  │                 └─Thread#join #{__dir__}/include_exclude/p.rb:7
  ├─Array#each #{__dir__}/include_exclude/o.rb:13
  │ ├─Thread#join #{__dir__}/include_exclude/o.rb:13
  │ └─Thread#join #{__dir__}/include_exclude/o.rb:13
  ├─Class#new #{__dir__}/include_exclude/o.rb:14
  │ └─BasicObject#initialize #{__dir__}/include_exclude/o.rb:14
  └─IncludeExcludeTest::P#p #{__dir__}/include_exclude/p.rb:3
    ├─IncludeExcludeTest::O#block in o #{__dir__}/include_exclude/o.rb:14
    ├─#<Class:Thread>#new #{__dir__}/include_exclude/p.rb:5
    │ └─Thread#initialize #{__dir__}/include_exclude/p.rb:5
    │   └─thread_run :0
    │     └─IncludeExcludeTest::P#block in p #{__dir__}/include_exclude/p.rb:5
    │       ├─Class#new #{__dir__}/include_exclude/p.rb:6
    │       │ └─BasicObject#initialize #{__dir__}/include_exclude/p.rb:6
    │       └─IncludeExcludeTest::Q#q #{__dir__}/include_exclude/q.rb:3
    │         └─ - - -
    └─Thread#join #{__dir__}/include_exclude/p.rb:7
  EOS

  def setup
    @sio = StringIO.new
    @no_methods = /^q$/
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, no_methods: @no_methods) do
      O.new.o
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'no_methods.html', no_methods: @no_methods) do
      O.new.o
    end
    assert_equal ReturnValue, rt
  end
end
