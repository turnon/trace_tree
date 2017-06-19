require 'test_helper'

class RaiseTest < Minitest::Test

  class Raise

    def entry
      result = exe
      out result
    end

    def entry!
      result = exe!
      out result
    end

    def exe
      boom
    rescue Boom => e
      save
    end

    def exe!
      boom
    end

    def boom
      raise Boom
    end

    def save
      ReturnValue
    end

    def out result
      result
    end

  end

  class Boom < StandardError;end

  Rescue = <<EOS
RaiseTest#block in test_rescue #{__dir__}/raise_test.rb:76
└─RaiseTest::Raise#entry #{__dir__}/raise_test.rb:7
  ├─RaiseTest::Raise#exe #{__dir__}/raise_test.rb:17
  │ ├─RaiseTest::Raise#boom #{__dir__}/raise_test.rb:27
  │ │ ├─Kernel#raise #{__dir__}/raise_test.rb:28
  │ │ │ └─#<Class:Exception>#exception #{__dir__}/raise_test.rb:28
  │ │ │   └─Exception#initialize #{__dir__}/raise_test.rb:28
  │ │ └─Exception#backtrace #{__dir__}/raise_test.rb:28
  │ ├─Module#=== #{__dir__}/raise_test.rb:19
  │ └─RaiseTest::Raise#save #{__dir__}/raise_test.rb:31
  └─RaiseTest::Raise#out #{__dir__}/raise_test.rb:35
EOS

  NoRescue = <<EOS
RaiseTest#block (2 levels) in test_no_rescue #{__dir__}/raise_test.rb:88
└─RaiseTest::Raise#entry! #{__dir__}/raise_test.rb:12
  └─RaiseTest::Raise#exe! #{__dir__}/raise_test.rb:23
    └─RaiseTest::Raise#boom #{__dir__}/raise_test.rb:27
      ├─Kernel#raise #{__dir__}/raise_test.rb:28
      │ └─#<Class:Exception>#exception #{__dir__}/raise_test.rb:28
      │   └─Exception#initialize #{__dir__}/raise_test.rb:28
      └─Exception#backtrace #{__dir__}/raise_test.rb:28
EOS

  ReturnValue = false

  def setup
    @test = Raise.new
    @sio = StringIO.new
  end

  def test_rescue
    rt = binding.trace_tree(@sio, color: false, out: Ignore) do
      @test.entry
    end

    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Rescue, @sio.read
  end

  def test_no_rescue
    assert_raises(Boom) do
      binding.trace_tree(@sio, color: false, out: Ignore) do
        @test.entry!
      end
    end

    @sio.rewind
    assert_equal NoRescue, @sio.read
  end

  def test_rescue_html
    rt = binding.trace_tree(html: true, tmp: 'raise_rescue.html', out: Ignore) do
      @test.entry
    end
    assert_equal ReturnValue, rt
  end

  def test_no_rescue_html
    assert_raises(Boom) do
      rt = binding.trace_tree(html: true, tmp: 'raise_no_rescue.html', out: Ignore) do
        @test.entry!
      end
    end
  end
end
