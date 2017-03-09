require 'test_helper'

class ClassTest < Minitest::Test

  Sio = StringIO.new

  Return = binding.trace_tree(Sio, color: false, ignore: Ignore) do
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
      end
    end

    module Q
      def self.extended base
      end
    end

    class R
    end

    class S
      def self.inherited base
      end
    end

    class A
      include M
      extend N
      prepend O
      include P
      extend Q

      class B < R
      end

      class C < S
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
ClassTest.block in <class:ClassTest> /home/z/trace_tree/test/class_test.rb:7
├─ClassTest::M.<module:M> /home/z/trace_tree/test/class_test.rb:8
│ └─Module.method_added /home/z/trace_tree/test/class_test.rb:9
├─ClassTest::N.<module:N> /home/z/trace_tree/test/class_test.rb:13
├─ClassTest::O.<module:O> /home/z/trace_tree/test/class_test.rb:16
├─ClassTest::P.<module:P> /home/z/trace_tree/test/class_test.rb:19
│ └─BasicObject.singleton_method_added /home/z/trace_tree/test/class_test.rb:20
├─ClassTest::Q.<module:Q> /home/z/trace_tree/test/class_test.rb:24
│ └─BasicObject.singleton_method_added /home/z/trace_tree/test/class_test.rb:25
├─Class.inherited /home/z/trace_tree/test/class_test.rb:29
├─ClassTest::R.<class:R> /home/z/trace_tree/test/class_test.rb:29
├─Class.inherited /home/z/trace_tree/test/class_test.rb:32
├─ClassTest::S.<class:S> /home/z/trace_tree/test/class_test.rb:32
│ └─BasicObject.singleton_method_added /home/z/trace_tree/test/class_test.rb:33
├─Class.inherited /home/z/trace_tree/test/class_test.rb:37
└─ClassTest::A.<class:A> /home/z/trace_tree/test/class_test.rb:37
  ├─Module.include /home/z/trace_tree/test/class_test.rb:38
  │ ├─Module.append_features /home/z/trace_tree/test/class_test.rb:38
  │ └─Module.included /home/z/trace_tree/test/class_test.rb:38
  ├─Kernel.extend /home/z/trace_tree/test/class_test.rb:39
  │ ├─Module.extend_object /home/z/trace_tree/test/class_test.rb:39
  │ └─Module.extended /home/z/trace_tree/test/class_test.rb:39
  ├─Module.prepend /home/z/trace_tree/test/class_test.rb:40
  │ ├─Module.prepend_features /home/z/trace_tree/test/class_test.rb:40
  │ └─Module.prepended /home/z/trace_tree/test/class_test.rb:40
  ├─Module.include /home/z/trace_tree/test/class_test.rb:41
  │ ├─Module.append_features /home/z/trace_tree/test/class_test.rb:41
  │ └─ClassTest::P.included /home/z/trace_tree/test/class_test.rb:20
  ├─Kernel.extend /home/z/trace_tree/test/class_test.rb:42
  │ ├─Module.extend_object /home/z/trace_tree/test/class_test.rb:42
  │ └─ClassTest::Q.extended /home/z/trace_tree/test/class_test.rb:25
  ├─Class.inherited /home/z/trace_tree/test/class_test.rb:44
  ├─ClassTest::A::B.<class:B> /home/z/trace_tree/test/class_test.rb:44
  ├─ClassTest::S.inherited /home/z/trace_tree/test/class_test.rb:33
  ├─ClassTest::A::C.<class:C> /home/z/trace_tree/test/class_test.rb:47
  ├─#<Class:ClassTest::A>.singleton class /home/z/trace_tree/test/class_test.rb:50
  │ └─BasicObject.singleton_method_added /home/z/trace_tree/test/class_test.rb:51
  ├─Module.method_added /home/z/trace_tree/test/class_test.rb:55
  ├─BasicObject.singleton_method_added /home/z/trace_tree/test/class_test.rb:58
  └─#<Class:ClassTest::A>.singleton class /home/z/trace_tree/test/class_test.rb:61
    └─BasicObject.singleton_method_added /home/z/trace_tree/test/class_test.rb:62
EOS

  def test_trace_tree
    assert_equal :d, Return

    Sio.rewind
    assert_equal Tracetree, Sio.read
  end

end
