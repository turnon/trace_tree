require 'test_helper'

class CreturnModulePrependfeaturesTest < Minitest::Test

  module M
  end

  module N
  end

  class C
  end

  Prepends = []
  Loader = TraceTree::Point::Loader.new TraceTree::Config::DEFAULT

  tp = TracePoint.trace(:c_return) do |t|
    Prepends << Loader.create(t) if t.method_id == :prepend_features
  end

  C.prepend M
  C.prepend N

  tp.disable unless tp.nil?

  def test_append_features
    assert_equal TraceTree::Point::CreturnModulePrependfeatures, Prepends[0].class
    assert_equal TraceTree::Point::CreturnModulePrependfeatures, Prepends[1].class
  end

  def test_mixin
    assert_equal M, Prepends[0].return_value
    assert_equal N, Prepends[1].return_value
  end

end
