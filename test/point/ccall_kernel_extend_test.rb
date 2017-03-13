require 'test_helper'

class CcallKernelExtendTest < Minitest::Test

  module M;end
  module N;end
  class C;end
  Co = C.new

  Extends = []
  Loader = TraceTree::Point::Loader.new

  tp = TracePoint.trace(:c_call, :c_return) do |t|
    Extends << Loader.create(t) if t.defined_class == Module or t.defined_class == Kernel
  end

  C.extend M
  Co.extend N

  tp.disable unless tp.nil?

  def test_extend
    assert_equal TraceTree::Point::CcallKernelExtend, Extends[0].class
    assert_equal TraceTree::Point::CcallModuleExtendobject, Extends[1].class
    assert_equal TraceTree::Point::CreturnModuleExtendobject, Extends[2].class
    assert_equal TraceTree::Point::Common, Extends[3].class
    assert_equal TraceTree::Point::Common, Extends[4].class
    assert_equal TraceTree::Point::Common, Extends[5].class

    assert_equal TraceTree::Point::CcallKernelExtend, Extends[6].class
    assert_equal TraceTree::Point::CcallModuleExtendobject, Extends[7].class
    assert_equal TraceTree::Point::CreturnModuleExtendobject, Extends[8].class
    assert_equal TraceTree::Point::Common, Extends[9].class
    assert_equal TraceTree::Point::Common, Extends[10].class
    assert_equal TraceTree::Point::Common, Extends[11].class
  end

  def test_mixin
    Extends[0] << Extends[1]
    Extends[1].terminal = Extends[2]
    assert_equal M, Extends[0].parameters
    assert_equal M, Extends[1].mixin
    assert_equal M, Extends[2].mixin

    Extends[6] << Extends[7]
    Extends[7].terminal = Extends[8]
    assert_equal N, Extends[6].parameters
    assert_equal N, Extends[7].mixin
    assert_equal N, Extends[8].mixin
  end

end
