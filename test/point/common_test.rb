require 'test_helper'

class CommonTest < Minitest::Test

  class A
    def a
    end
  end

  def setup
    @ttp = nil
    @loader = TraceTree::Point::Loader.new TraceTree::Config::DEFAULT
  end

  def test_common
    tp = TracePoint.trace(:call) do |t|
      @ttp = @loader.create t
    end
    A.new.a
  ensure
    tp.disable unless tp.nil?
    assert_equal TraceTree::Point::Common, @ttp.class
  end

end
