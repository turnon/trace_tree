require 'test_helper'

class CcallModulePrependTest < Minitest::Test

  module M
  end

  class C
  end

  Prepends = []
  Loader = TraceTree::Point::Loader.new

  tp = TracePoint.trace(:c_call, :c_return) do |t|
    Prepends << Loader.create(t) if t.defined_class == Module
  end

  C.prepend M

  tp.disable unless tp.nil?

  def test_include
    assert_equal TraceTree::Point::CcallModulePrepend, Prepends[0].class
    assert_equal TraceTree::Point::CcallModulePrependfeatures, Prepends[1].class
    assert_equal TraceTree::Point::CreturnModulePrependfeatures, Prepends[2].class
    assert_equal TraceTree::Point::Common, Prepends[3].class
    assert_equal TraceTree::Point::Common, Prepends[4].class
    assert_equal TraceTree::Point::Common, Prepends[5].class
  end

  def test_mixin
    Prepends[0] << Prepends[1]
    Prepends[1].terminal = Prepends[2]
    assert_equal M, Prepends[0].parameters
    assert_equal M, Prepends[1].parameters
    assert_equal M, Prepends[2].return_value
  end

end
