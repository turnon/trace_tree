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
ThreadTest#block in test_trace_tree /home/z/trace_tree/test/thread_test.rb:45
└─ThreadTest::MultiThreads#a /home/z/trace_tree/test/thread_test.rb:7
  ├─Integer#times /home/z/trace_tree/test/thread_test.rb:8
  ├─Enumerable#map /home/z/trace_tree/test/thread_test.rb:8
  │ └─Enumerator#each /home/z/trace_tree/test/thread_test.rb:8
  │   └─Integer#times /home/z/trace_tree/test/thread_test.rb:8
  │     ├─ThreadTest::MultiThreads#block in a /home/z/trace_tree/test/thread_test.rb:8
  │     │ └─#<Class:Thread>#new /home/z/trace_tree/test/thread_test.rb:9
  │     │   └─Thread#initialize /home/z/trace_tree/test/thread_test.rb:9
  │     │     └─thread_run :0
  │     │       └─ThreadTest::MultiThreads#block (2 levels) in a /home/z/trace_tree/test/thread_test.rb:9
  │     └─ThreadTest::MultiThreads#block in a /home/z/trace_tree/test/thread_test.rb:8
  │       └─#<Class:Thread>#new /home/z/trace_tree/test/thread_test.rb:9
  │         └─Thread#initialize /home/z/trace_tree/test/thread_test.rb:9
  │           └─thread_run :0
  │             └─ThreadTest::MultiThreads#block (2 levels) in a /home/z/trace_tree/test/thread_test.rb:9
  └─Array#each /home/z/trace_tree/test/thread_test.rb:12
    ├─Thread#join /home/z/trace_tree/test/thread_test.rb:12
    └─Thread#join /home/z/trace_tree/test/thread_test.rb:12
EOS

  def setup
    @test = MultiThreads.new
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, ignore: Ignore) do
      @test.a
    end

    #assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  #def test_trace_tree_html
  #  rt = binding.trace_tree(html: true, tmp: 'normal.html', ignore: Ignore) do
  #    @test.a
  #  end
  #  assert_equal ReturnValue, rt
  #end

end
