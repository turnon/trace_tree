require 'test_helper'

class ThreadPointsTest < Minitest::Test

  attr_reader :thread_count, :points

  def setup
    @loader = TraceTree::Point::Loader.new TraceTree::Config::DEFAULT
    @q = Queue.new
    @thread_count = 3
  end

  def test_thread_begin
    tp = TracePoint.trace(*TraceTree::Events) do |t|
      point = @loader.create(t)
      @q.enq point if point.path == __FILE__ or point.path.nil?
    end

    n = 1

    threads = thread_count.times.map do
      Thread.new do
        n = 2
      end
    end

    threads.each(&:join)
  ensure
    tp.disable unless tp.nil?
    @points = q_to_a @q
    assert_threads_begin
    assert_threads_end
    assert_thread_news_ccall
    assert_thread_news_creturn
    assert_thread_inits_ccall
    assert_thread_inits_creturn
    assert_total_thread_count
  end

  private

  def q_to_a q
    a = []
    a << q.deq until q.size == 0
    a
  end

  def assert_threads_begin
    thread_begins = points.select{|poi| poi.kind_of? TraceTree::Point::Threadbegin}
    assert_equal thread_count, thread_begins.count
  end

  def assert_threads_end
    thread_ends = points.select{|poi| poi.kind_of? TraceTree::Point::Threadend}
    assert_equal thread_count, thread_ends.count
  end

  def assert_thread_news_ccall
    thread_news = points.select{|poi| poi.kind_of? TraceTree::Point::CcallClassthreadNew}
    assert_equal thread_count, thread_news.count
  end

  def assert_thread_news_creturn
    thread_news = points.select{|poi| poi.kind_of? TraceTree::Point::CreturnClassthreadNew}
    assert_equal thread_count, thread_news.count
  end

  def assert_thread_inits_ccall
    thread_inits = points.select{|poi| poi.kind_of? TraceTree::Point::CcallThreadInitialize}
    assert_equal thread_count, thread_inits.count
  end

  def assert_thread_inits_creturn
    thread_inits = points.select{|poi| poi.kind_of? TraceTree::Point::CreturnThreadInitialize}
    assert_equal thread_count, thread_inits.count
  end

  def assert_total_thread_count
    assert_equal (thread_count + 1), points.group_by(&:thread).count
  end
end
