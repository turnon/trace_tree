require 'test_helper'

class ClassTest < Minitest::Test

  Sio = StringIO.new

  Return = binding.trace_tree(Sio, color: false, out: Ignore) do
    module M
      def m
      end
    end

    module N
    end

    module O
    end

    module P
      def self.included base
        not_base = 1
      end
    end

    module Q
      def self.extended base
        not_base = 2
      end
    end

    module R
      def self.prepended base
        note_base = 3
      end
    end

    class Y
    end

    class Z
      def self.inherited base
        not_base = 4
      end
    end

    class A
      include M
      extend N
      prepend O
      include P
      extend Q
      prepend R

      class B < Y
      end

      class C < Z
      end

      class << self
        def a
        end
      end

      def b
      end

      def self.c
      end

      class << self
        def d
        end
      end
    end
  end

  def test_trace_tree
    assert_equal :d, Return

    Sio.rewind
    assert_equal tree_graph, Sio.read
  end

  def tree_graph
    if RB_VER < 3.2
<<-EOS
ClassTest.block in <class:ClassTest> #{__FILE__}:7
├─ClassTest::M.<module:M> #{__FILE__}:8
│ └─Module#method_added #{__FILE__}:9
├─ClassTest::N.<module:N> #{__FILE__}:13
├─ClassTest::O.<module:O> #{__FILE__}:16
├─ClassTest::P.<module:P> #{__FILE__}:19
│ └─BasicObject#singleton_method_added #{__FILE__}:20
├─ClassTest::Q.<module:Q> #{__FILE__}:25
│ └─BasicObject#singleton_method_added #{__FILE__}:26
├─ClassTest::R.<module:R> #{__FILE__}:31
│ └─BasicObject#singleton_method_added #{__FILE__}:32
├─Class#inherited #{__FILE__}:37
├─ClassTest::Y.<class:Y> #{__FILE__}:37
├─Class#inherited #{__FILE__}:40
├─ClassTest::Z.<class:Z> #{__FILE__}:40
│ └─BasicObject#singleton_method_added #{__FILE__}:41
├─Class#inherited #{__FILE__}:46
└─ClassTest::A.<class:A> #{__FILE__}:46
  ├─Module#include(ClassTest::M) #{__FILE__}:47
  │ ├─Module#append_features #{__FILE__}:47
  │ └─Module#included #{__FILE__}:47
  ├─Kernel#extend(ClassTest::N) #{__FILE__}:48
  │ ├─Module#extend_object #{__FILE__}:48
  │ └─Module#extended #{__FILE__}:48
  ├─Module#prepend(ClassTest::O) #{__FILE__}:49
  │ ├─Module#prepend_features #{__FILE__}:49
  │ └─Module#prepended #{__FILE__}:49
  ├─Module#include(ClassTest::P) #{__FILE__}:50
  │ ├─Module#append_features #{__FILE__}:50
  │ └─ClassTest::P.included #{__FILE__}:20
  ├─Kernel#extend(ClassTest::Q) #{__FILE__}:51
  │ ├─Module#extend_object #{__FILE__}:51
  │ └─ClassTest::Q.extended #{__FILE__}:26
  ├─Module#prepend(ClassTest::R) #{__FILE__}:52
  │ ├─Module#prepend_features #{__FILE__}:52
  │ └─ClassTest::R.prepended #{__FILE__}:32
  ├─Class#inherited #{__FILE__}:54
  ├─ClassTest::A::B.<class:B> #{__FILE__}:54
  ├─ClassTest::Z.inherited #{__FILE__}:41
  ├─ClassTest::A::C.<class:C> #{__FILE__}:57
  ├─#<Class:ClassTest::A>.singleton class #{__FILE__}:60
  │ └─BasicObject#singleton_method_added #{__FILE__}:61
  ├─Module#method_added #{__FILE__}:65
  ├─BasicObject#singleton_method_added #{__FILE__}:68
  └─#<Class:ClassTest::A>.singleton class #{__FILE__}:71
    └─BasicObject#singleton_method_added #{__FILE__}:72
EOS
    else
<<-EOS
ClassTest.block in <class:ClassTest> #{__FILE__}:7
├─Module#const_added #{__FILE__}:8
├─ClassTest::M.<module:M> #{__FILE__}:8
│ └─Module#method_added #{__FILE__}:9
├─Module#const_added #{__FILE__}:13
├─ClassTest::N.<module:N> #{__FILE__}:13
├─Module#const_added #{__FILE__}:16
├─ClassTest::O.<module:O> #{__FILE__}:16
├─Module#const_added #{__FILE__}:19
├─ClassTest::P.<module:P> #{__FILE__}:19
│ └─BasicObject#singleton_method_added #{__FILE__}:20
├─Module#const_added #{__FILE__}:25
├─ClassTest::Q.<module:Q> #{__FILE__}:25
│ └─BasicObject#singleton_method_added #{__FILE__}:26
├─Module#const_added #{__FILE__}:31
├─ClassTest::R.<module:R> #{__FILE__}:31
│ └─BasicObject#singleton_method_added #{__FILE__}:32
├─Module#const_added #{__FILE__}:37
├─Class#inherited #{__FILE__}:37
├─ClassTest::Y.<class:Y> #{__FILE__}:37
├─Module#const_added #{__FILE__}:40
├─Class#inherited #{__FILE__}:40
├─ClassTest::Z.<class:Z> #{__FILE__}:40
│ └─BasicObject#singleton_method_added #{__FILE__}:41
├─Module#const_added #{__FILE__}:46
├─Class#inherited #{__FILE__}:46
└─ClassTest::A.<class:A> #{__FILE__}:46
  ├─Module#include(ClassTest::M) #{__FILE__}:47
  │ ├─Module#append_features #{__FILE__}:47
  │ └─Module#included #{__FILE__}:47
  ├─Kernel#extend(ClassTest::N) #{__FILE__}:48
  │ ├─Module#extend_object #{__FILE__}:48
  │ └─Module#extended #{__FILE__}:48
  ├─Module#prepend(ClassTest::O) #{__FILE__}:49
  │ ├─Module#prepend_features #{__FILE__}:49
  │ └─Module#prepended #{__FILE__}:49
  ├─Module#include(ClassTest::P) #{__FILE__}:50
  │ ├─Module#append_features #{__FILE__}:50
  │ └─ClassTest::P.included #{__FILE__}:20
  ├─Kernel#extend(ClassTest::Q) #{__FILE__}:51
  │ ├─Module#extend_object #{__FILE__}:51
  │ └─ClassTest::Q.extended #{__FILE__}:26
  ├─Module#prepend(ClassTest::R) #{__FILE__}:52
  │ ├─Module#prepend_features #{__FILE__}:52
  │ └─ClassTest::R.prepended #{__FILE__}:32
  ├─Module#const_added #{__FILE__}:54
  ├─Class#inherited #{__FILE__}:54
  ├─ClassTest::A::B.<class:B> #{__FILE__}:54
  ├─Module#const_added #{__FILE__}:57
  ├─ClassTest::Z.inherited #{__FILE__}:41
  ├─ClassTest::A::C.<class:C> #{__FILE__}:57
  ├─#<Class:ClassTest::A>.singleton class #{__FILE__}:60
  │ └─BasicObject#singleton_method_added #{__FILE__}:61
  ├─Module#method_added #{__FILE__}:65
  ├─BasicObject#singleton_method_added #{__FILE__}:68
  └─#<Class:ClassTest::A>.singleton class #{__FILE__}:71
    └─BasicObject#singleton_method_added #{__FILE__}:72
EOS
    end
  end
end
