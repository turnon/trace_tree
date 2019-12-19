require 'test_helper'

class WarmUpTest < Minitest::Test
  class A
    def initialize
      @a = 0
    end

    def a
      @a += 1
    end
  end

  Tracetree = <<-EOS
WarmUpTest#block in test_warm_up #{__dir__}/warm_up_test.rb:36
└─WarmUpTest::A#a #{__dir__}/warm_up_test.rb:9
EOS

  def setup
    @a = A.new
    @first = StringIO.new
    @second = StringIO.new
  end

  def test_warm_up
    rt = binding.trace_tree(@first, color: false, out: Ignore, warm: @a.object_id) do
      @a.a
    end

    assert_equal 1, rt

    @first.rewind
    assert_equal '', @first.read


    rt = binding.trace_tree(@second, color: false, out: Ignore, warm: @a.object_id) do
      @a.a
    end

    assert_equal 2, rt

    @second.rewind
    assert_equal Tracetree, @second.read
  end
end
