require 'test_helper'

class MatcherTest < Minitest::Test

  module M
  end

  module N
  end

  class A
    include M
    def a
      B.new.b
    end
  end

  class B
    include M
    def b
    end
  end

  def test_matchers
    [TraceTree::Matcher::Include.new({path: /matcher/}),
     TraceTree::Matcher::Include.new({type: M}),
     TraceTree::Matcher::Include.new({path: /qwertyuuiop/, type: M}),
     TraceTree::Matcher::Exclude.new({path: /matcher/}),
     TraceTree::Matcher::Exclude.new({type: M}),
     TraceTree::Matcher::Include.new({path: /qwertyuuiop/, type: M})
    ].each_with_index do |m, i|
       trace do |tp|
         assert m.match?(tp), "fail case #{i}"
       end
     end
  end

  def test_matchers_not_matched
    [TraceTree::Matcher::Include.new({path: /qwertyuiop/, type: N}),
     TraceTree::Matcher::Exclude.new({path: /qwertyuiop/, type: N})
    ].each_with_index do |m, i|
      trace do |tp|
        refute m.match?(tp), "fail case #{i}"
      end
    end
  end

  def test_include_not_specified
    m = TraceTree::Matcher::Include.new
    trace do |tp|
      assert m.match?(tp)
    end
  end

  def test_exclude_not_specified
    m = TraceTree::Matcher::Exclude.new
    trace do |tp|
      refute m.match?(tp)
    end
  end

  private

  def trace &block
    tp = TracePoint.new :call, &block
    tp.enable
    A.new.a
  ensure
    tp.disable
  end


end
