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

  Tracetree = <<EOS
ClassTest.block in <class:ClassTest> #{__dir__}/class_test.rb:7
├─ClassTest::M.<module:M> #{__dir__}/class_test.rb:8
│ └─Module#method_added #{__dir__}/class_test.rb:9
├─ClassTest::N.<module:N> #{__dir__}/class_test.rb:13
├─ClassTest::O.<module:O> #{__dir__}/class_test.rb:16
├─ClassTest::P.<module:P> #{__dir__}/class_test.rb:19
│ └─BasicObject#singleton_method_added #{__dir__}/class_test.rb:20
├─ClassTest::Q.<module:Q> #{__dir__}/class_test.rb:25
│ └─BasicObject#singleton_method_added #{__dir__}/class_test.rb:26
├─ClassTest::R.<module:R> #{__dir__}/class_test.rb:31
│ └─BasicObject#singleton_method_added #{__dir__}/class_test.rb:32
├─Class#inherited #{__dir__}/class_test.rb:37
├─ClassTest::Y.<class:Y> #{__dir__}/class_test.rb:37
├─Class#inherited #{__dir__}/class_test.rb:40
├─ClassTest::Z.<class:Z> #{__dir__}/class_test.rb:40
│ └─BasicObject#singleton_method_added #{__dir__}/class_test.rb:41
├─Class#inherited #{__dir__}/class_test.rb:46
└─ClassTest::A.<class:A> #{__dir__}/class_test.rb:46
  ├─Module#include(ClassTest::M) #{__dir__}/class_test.rb:47
  │ ├─Module#append_features #{__dir__}/class_test.rb:47
  │ └─Module#included #{__dir__}/class_test.rb:47
  ├─Kernel#extend(ClassTest::N) #{__dir__}/class_test.rb:48
  │ ├─Module#extend_object #{__dir__}/class_test.rb:48
  │ └─Module#extended #{__dir__}/class_test.rb:48
  ├─Module#prepend(ClassTest::O) #{__dir__}/class_test.rb:49
  │ ├─Module#prepend_features #{__dir__}/class_test.rb:49
  │ └─Module#prepended #{__dir__}/class_test.rb:49
  ├─Module#include(ClassTest::P) #{__dir__}/class_test.rb:50
  │ ├─Module#append_features #{__dir__}/class_test.rb:50
  │ └─ClassTest::P.included #{__dir__}/class_test.rb:20
  ├─Kernel#extend(ClassTest::Q) #{__dir__}/class_test.rb:51
  │ ├─Module#extend_object #{__dir__}/class_test.rb:51
  │ └─ClassTest::Q.extended #{__dir__}/class_test.rb:26
  ├─Module#prepend(ClassTest::R) #{__dir__}/class_test.rb:52
  │ ├─Module#prepend_features #{__dir__}/class_test.rb:52
  │ └─ClassTest::R.prepended #{__dir__}/class_test.rb:32
  ├─Class#inherited #{__dir__}/class_test.rb:54
  ├─ClassTest::A::B.<class:B> #{__dir__}/class_test.rb:54
  ├─ClassTest::Z.inherited #{__dir__}/class_test.rb:41
  ├─ClassTest::A::C.<class:C> #{__dir__}/class_test.rb:57
  ├─#<Class:ClassTest::A>.singleton class #{__dir__}/class_test.rb:60
  │ └─BasicObject#singleton_method_added #{__dir__}/class_test.rb:61
  ├─Module#method_added #{__dir__}/class_test.rb:65
  ├─BasicObject#singleton_method_added #{__dir__}/class_test.rb:68
  └─#<Class:ClassTest::A>.singleton class #{__dir__}/class_test.rb:71
    └─BasicObject#singleton_method_added #{__dir__}/class_test.rb:72
EOS

  def test_trace_tree
    assert_equal :d, Return

    Sio.rewind
    assert_equal Tracetree, Sio.read

  end

end
