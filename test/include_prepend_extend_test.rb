require 'test_helper'

class IncludePrependExtendTest < Minitest::Test
  module M
  end

  module N
    class << self
      def included(base)
        super
      end

      def append_features(base)
        super
      end
    end
  end

  module O
  end

  module P
    class << self
      def prepended(base)
        super
      end

      def prepend_features(base)
        super
      end
    end
  end

  module Q
  end

  module R
    class << self
      def extended(base)
        super
      end

      def extend_object(base)
        super
      end
    end
  end

  class C
  end

  Mixin = -> do
    klass = Class.new C
    klass.include M
    klass.include N
    klass.prepend O
    klass.prepend P
    klass.extend Q
    klass.extend R
  end

  Tracetree = <<EOS
IncludePrependExtendTest#block in test_trace_tree #{__dir__}/include_prepend_extend_test.rb:99
└─IncludePrependExtendTest.block in <class:IncludePrependExtendTest> #{__dir__}/include_prepend_extend_test.rb:52
  ├─Class#new #{__dir__}/include_prepend_extend_test.rb:53
  │ └─Class#initialize #{__dir__}/include_prepend_extend_test.rb:53
  │   └─Class#inherited #{__dir__}/include_prepend_extend_test.rb:53
  ├─Module#include(IncludePrependExtendTest::M) #{__dir__}/include_prepend_extend_test.rb:54
  │ ├─Module#append_features #{__dir__}/include_prepend_extend_test.rb:54
  │ └─Module#included #{__dir__}/include_prepend_extend_test.rb:54
  ├─Module#include(IncludePrependExtendTest::N) #{__dir__}/include_prepend_extend_test.rb:55
  │ ├─IncludePrependExtendTest::N.append_features #{__dir__}/include_prepend_extend_test.rb:13
  │ │ └─Module#append_features #{__dir__}/include_prepend_extend_test.rb:14
  │ └─IncludePrependExtendTest::N.included #{__dir__}/include_prepend_extend_test.rb:9
  │   └─Module#included #{__dir__}/include_prepend_extend_test.rb:10
  ├─Module#prepend(IncludePrependExtendTest::O) #{__dir__}/include_prepend_extend_test.rb:56
  │ ├─Module#prepend_features #{__dir__}/include_prepend_extend_test.rb:56
  │ └─Module#prepended #{__dir__}/include_prepend_extend_test.rb:56
  ├─Module#prepend(IncludePrependExtendTest::P) #{__dir__}/include_prepend_extend_test.rb:57
  │ ├─IncludePrependExtendTest::P.prepend_features #{__dir__}/include_prepend_extend_test.rb:28
  │ │ └─Module#prepend_features #{__dir__}/include_prepend_extend_test.rb:29
  │ └─IncludePrependExtendTest::P.prepended #{__dir__}/include_prepend_extend_test.rb:24
  │   └─Module#prepended #{__dir__}/include_prepend_extend_test.rb:25
  ├─Kernel#extend(IncludePrependExtendTest::Q) #{__dir__}/include_prepend_extend_test.rb:58
  │ ├─Module#extend_object #{__dir__}/include_prepend_extend_test.rb:58
  │ └─Module#extended #{__dir__}/include_prepend_extend_test.rb:58
  └─Kernel#extend(IncludePrependExtendTest::R) #{__dir__}/include_prepend_extend_test.rb:59
    ├─IncludePrependExtendTest::R.extend_object #{__dir__}/include_prepend_extend_test.rb:43
    │ └─Module#extend_object #{__dir__}/include_prepend_extend_test.rb:44
    └─IncludePrependExtendTest::R.extended #{__dir__}/include_prepend_extend_test.rb:39
      └─Module#extended #{__dir__}/include_prepend_extend_test.rb:40
EOS

  def setup
    @sio = StringIO.new
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      Mixin.call
    end

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'include_prepend_extend.html', out: Ignore) do
      Mixin.call
    end
  end

end
