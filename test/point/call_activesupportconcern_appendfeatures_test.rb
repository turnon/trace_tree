require 'test_helper'
require 'active_support/concern'

class CallActivesupportconcernAppendfeaturesTest < Minitest::Test

  module M
  end

  module N
    extend ActiveSupport::Concern
  end

  module O
    extend ActiveSupport::Concern
    include N
  end

  class C
  end

  Includes = []
  Loader = TraceTree::Point::Loader.new

  tp = TracePoint.trace(*TraceTree::Events) do |t|
    Includes << Loader.create(t) if t.method_id == :append_features and [:c_call, :call].include? t.event
  end

  C.include M
  C.include O

  tp.disable unless tp.nil?

  def test_include
    assert_equal TraceTree::Point::CcallModuleAppendfeatures, Includes[0].class
    assert_equal TraceTree::Point::CallActivesupportconcernAppendfeatures, Includes[1].class
    assert_equal TraceTree::Point::CallActivesupportconcernAppendfeatures, Includes[2].class
    assert_equal TraceTree::Point::CcallModuleAppendfeatures, Includes[3].class
    assert_equal TraceTree::Point::CcallModuleAppendfeatures, Includes[4].class
  end

end
