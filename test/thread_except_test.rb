require 'test_helper'

class ThreadExceptTest < Minitest::Test

  class MultiThreads

    def a
      ts = 4.times.map{ Thread.new{ b } }
      ts.each(&:join)
    end

    def b(n = 2)
      c
      TraceTree.except{ c }
      n > 0 ? b(n - 1) : d
    end

    def c
    end

    def d
      ReturnValue
    end
  end

  ReturnValue = '1234567'

  Tracetree = <<EOS
ThreadExceptTest#block in test_trace_tree #{__dir__}/thread_except_test.rb:108
└─ThreadExceptTest::MultiThreads#a #{__dir__}/thread_except_test.rb:7
  ├─Integer#times #{__dir__}/thread_except_test.rb:8
  ├─Enumerable#map #{__dir__}/thread_except_test.rb:8
  │ └─Enumerator#each #{__dir__}/thread_except_test.rb:8
  │   └─Integer#times #{__dir__}/thread_except_test.rb:8
  │     ├─ThreadExceptTest::MultiThreads#block in a #{__dir__}/thread_except_test.rb:8
  │     │ └─#<Class:Thread>#new #{__dir__}/thread_except_test.rb:8
  │     │   └─Thread#initialize #{__dir__}/thread_except_test.rb:8
  │     │     └─thread_run :0
  │     │       └─ThreadExceptTest::MultiThreads#block (2 levels) in a #{__dir__}/thread_except_test.rb:8
  │     │         └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │           ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │           ├─#{Except}
  │     │           └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │             ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │             ├─#{Except}
  │     │             └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │               ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │               ├─#{Except}
  │     │               └─ThreadExceptTest::MultiThreads#d #{__dir__}/thread_except_test.rb:21
  │     ├─ThreadExceptTest::MultiThreads#block in a #{__dir__}/thread_except_test.rb:8
  │     │ └─#<Class:Thread>#new #{__dir__}/thread_except_test.rb:8
  │     │   └─Thread#initialize #{__dir__}/thread_except_test.rb:8
  │     │     └─thread_run :0
  │     │       └─ThreadExceptTest::MultiThreads#block (2 levels) in a #{__dir__}/thread_except_test.rb:8
  │     │         └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │           ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │           ├─#{Except}
  │     │           └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │             ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │             ├─#{Except}
  │     │             └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │               ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │               ├─#{Except}
  │     │               └─ThreadExceptTest::MultiThreads#d #{__dir__}/thread_except_test.rb:21
  │     ├─ThreadExceptTest::MultiThreads#block in a #{__dir__}/thread_except_test.rb:8
  │     │ └─#<Class:Thread>#new #{__dir__}/thread_except_test.rb:8
  │     │   └─Thread#initialize #{__dir__}/thread_except_test.rb:8
  │     │     └─thread_run :0
  │     │       └─ThreadExceptTest::MultiThreads#block (2 levels) in a #{__dir__}/thread_except_test.rb:8
  │     │         └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │           ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │           ├─#{Except}
  │     │           └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │             ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │             ├─#{Except}
  │     │             └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │     │               ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │     │               ├─#{Except}
  │     │               └─ThreadExceptTest::MultiThreads#d #{__dir__}/thread_except_test.rb:21
  │     └─ThreadExceptTest::MultiThreads#block in a #{__dir__}/thread_except_test.rb:8
  │       └─#<Class:Thread>#new #{__dir__}/thread_except_test.rb:8
  │         └─Thread#initialize #{__dir__}/thread_except_test.rb:8
  │           └─thread_run :0
  │             └─ThreadExceptTest::MultiThreads#block (2 levels) in a #{__dir__}/thread_except_test.rb:8
  │               └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │                 ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │                 ├─#{Except}
  │                 └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │                   ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │                   ├─#{Except}
  │                   └─ThreadExceptTest::MultiThreads#b #{__dir__}/thread_except_test.rb:12
  │                     ├─ThreadExceptTest::MultiThreads#c #{__dir__}/thread_except_test.rb:18
  │                     ├─#{Except}
  │                     └─ThreadExceptTest::MultiThreads#d #{__dir__}/thread_except_test.rb:21
  └─Array#each #{__dir__}/thread_except_test.rb:9
    ├─Thread#join #{__dir__}/thread_except_test.rb:9
    ├─Thread#join #{__dir__}/thread_except_test.rb:9
    ├─Thread#join #{__dir__}/thread_except_test.rb:9
    └─Thread#join #{__dir__}/thread_except_test.rb:9
EOS

  def setup
    @test = MultiThreads.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore, except: true) do
      @test.a
    end

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'thread.html', out: Ignore, except: true) do
      @test.a
    end
  end

end
