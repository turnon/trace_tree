require 'test_helper'

class CreturnModuleAppendfeaturesTest < Minitest::Test

  module M
  end

  module N
  end

  class C
  end

  Includes = []

  tp = TracePoint.trace(:c_return) do |t|
    Includes << TraceTree::Point.save(t) if t.method_id == :append_features
  end

  C.include M
  C.include N

  tp.disable unless tp.nil?

  def test_append_features
    assert_equal TraceTree::Point::CreturnModuleAppendfeatures, Includes[0].class
    assert_equal TraceTree::Point::CreturnModuleAppendfeatures, Includes[1].class
  end

  def test_mixin
    assert_equal M, Includes[0].return_value
    assert_equal N, Includes[1].return_value
  end

end
