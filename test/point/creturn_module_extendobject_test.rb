require 'test_helper'

class CreturnModuleExtendobjectTest < Minitest::Test

  module M
  end

  module N
  end

  class C
  end

  Extends = []
  Loader = TraceTree::Point::Loader.new TraceTree::Config::DEFAULT

  tp = TracePoint.trace(:c_return) do |t|
    Extends << Loader.create(t) if t.method_id == :extend_object
  end

  C.extend M
  C.extend N

  tp.disable unless tp.nil?

  def test_extend
    assert_equal TraceTree::Point::CreturnModuleExtendobject, Extends[0].class
    assert_equal TraceTree::Point::CreturnModuleExtendobject, Extends[1].class
  end

  def test_mixin
    assert_equal C, Extends[0].return_value
    assert_equal C, Extends[1].return_value
  end

end
