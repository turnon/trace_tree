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

  Mixin = -> do
    Class.new do
      include M
      include N
      prepend O
      prepend P
      extend R
      extend Q
    end
  end

  Tracetree = <<EOS
IncludePrependExtendTest#block in test_trace_tree #{__dir__}/include_prepend_extend_test.rb:98
└─IncludePrependExtendTest.block in <class:IncludePrependExtendTest> #{__dir__}/include_prepend_extend_test.rb:49
  └─Class#new #{__dir__}/include_prepend_extend_test.rb:50
    └─Class#initialize #{__dir__}/include_prepend_extend_test.rb:50
      ├─Class#inherited #{__dir__}/include_prepend_extend_test.rb:50
      └─#<Class:0xXXXXXX>.block (2 levels) in <class:IncludePrependExtendTest> #{__dir__}/include_prepend_extend_test.rb:50
        ├─Module#include(IncludePrependExtendTest::M) #{__dir__}/include_prepend_extend_test.rb:51
        │ ├─Module#append_features #{__dir__}/include_prepend_extend_test.rb:51
        │ └─Module#included #{__dir__}/include_prepend_extend_test.rb:51
        ├─Module#include(IncludePrependExtendTest::N) #{__dir__}/include_prepend_extend_test.rb:52
        │ ├─IncludePrependExtendTest::N.append_features #{__dir__}/include_prepend_extend_test.rb:13
        │ │ └─Module#append_features #{__dir__}/include_prepend_extend_test.rb:14
        │ └─IncludePrependExtendTest::N.included #{__dir__}/include_prepend_extend_test.rb:9
        │   └─Module#included #{__dir__}/include_prepend_extend_test.rb:10
        ├─Module#prepend(IncludePrependExtendTest::O) #{__dir__}/include_prepend_extend_test.rb:53
        │ ├─Module#prepend_features #{__dir__}/include_prepend_extend_test.rb:53
        │ └─Module#prepended #{__dir__}/include_prepend_extend_test.rb:53
        ├─Module#prepend(IncludePrependExtendTest::P) #{__dir__}/include_prepend_extend_test.rb:54
        │ ├─IncludePrependExtendTest::P.prepend_features #{__dir__}/include_prepend_extend_test.rb:28
        │ │ └─Module#prepend_features #{__dir__}/include_prepend_extend_test.rb:29
        │ └─IncludePrependExtendTest::P.prepended #{__dir__}/include_prepend_extend_test.rb:24
        │   └─Module#prepended #{__dir__}/include_prepend_extend_test.rb:25
        ├─Kernel#extend(IncludePrependExtendTest::R) #{__dir__}/include_prepend_extend_test.rb:55
        │ ├─IncludePrependExtendTest::R.extend_object #{__dir__}/include_prepend_extend_test.rb:43
        │ │ └─Module#extend_object #{__dir__}/include_prepend_extend_test.rb:44
        │ └─IncludePrependExtendTest::R.extended #{__dir__}/include_prepend_extend_test.rb:39
        │   └─Module#extended #{__dir__}/include_prepend_extend_test.rb:40
        └─Kernel#extend(IncludePrependExtendTest::Q) #{__dir__}/include_prepend_extend_test.rb:56
          ├─Module#extend_object #{__dir__}/include_prepend_extend_test.rb:56
          └─Module#extended #{__dir__}/include_prepend_extend_test.rb:56
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
