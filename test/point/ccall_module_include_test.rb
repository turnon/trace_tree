require 'test_helper'

class CcallModuleIncludeTest < Minitest::Test

  module M
  end

  class C
  end

  Includes = []
  Loader = TraceTree::Point::Loader.new TraceTree::Config::DEFAULT

  tp = TracePoint.trace(:c_call, :c_return) do |t|
    Includes << Loader.create(t) if t.defined_class == Module
  end

  C.include M

  tp.disable unless tp.nil?

  def test_include
    assert_equal TraceTree::Point::CcallModuleInclude, Includes[0].class
    assert_equal TraceTree::Point::CcallModuleAppendfeatures, Includes[1].class
    assert_equal TraceTree::Point::CreturnModuleAppendfeatures, Includes[2].class
    assert_equal TraceTree::Point::Common, Includes[3].class
    assert_equal TraceTree::Point::Common, Includes[4].class
    assert_equal TraceTree::Point::Common, Includes[5].class
  end

  def test_mixin
    Includes[0].has_callee Includes[1]
    Includes[1].terminal = Includes[2]
    assert_equal M, Includes[0].parameters
    assert_equal M, Includes[1].parameters
    assert_equal M, Includes[2].return_value
  end

end
