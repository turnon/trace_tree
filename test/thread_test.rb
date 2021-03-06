require 'test_helper'

class ThreadTest < Minitest::Test

  class MultiThreads

    def a
      ts = 2.times.map do
        Thread.new do
        end
      end
      ts.each(&:join)
    end

  end

  Tracetree = <<EOS
ThreadTest#block in test_trace_tree #{__dir__}/thread_test.rb:45
└─ThreadTest::MultiThreads#a #{__dir__}/thread_test.rb:7
  ├─Integer#times #{__dir__}/thread_test.rb:8
  ├─Enumerable#map #{__dir__}/thread_test.rb:8
  │ └─Enumerator#each #{__dir__}/thread_test.rb:8
  │   └─Integer#times #{__dir__}/thread_test.rb:8
  │     ├─ThreadTest::MultiThreads#block in a #{__dir__}/thread_test.rb:8
  │     │ └─#<Class:Thread>#new #{__dir__}/thread_test.rb:9
  │     │   └─Thread#initialize #{__dir__}/thread_test.rb:9
  │     │     └─thread_run :0
  │     │       └─ThreadTest::MultiThreads#block (2 levels) in a #{__dir__}/thread_test.rb:9
  │     └─ThreadTest::MultiThreads#block in a #{__dir__}/thread_test.rb:8
  │       └─#<Class:Thread>#new #{__dir__}/thread_test.rb:9
  │         └─Thread#initialize #{__dir__}/thread_test.rb:9
  │           └─thread_run :0
  │             └─ThreadTest::MultiThreads#block (2 levels) in a #{__dir__}/thread_test.rb:9
  └─Array#each #{__dir__}/thread_test.rb:12
    ├─Thread#join #{__dir__}/thread_test.rb:12
    └─Thread#join #{__dir__}/thread_test.rb:12
EOS

  def setup
    @test = MultiThreads.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.a
    end

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'thread.html', out: Ignore) do
      @test.a
    end
  end

end
