require 'test_helper'

class IncludeExcludeTest < Minitest::Test

  classes_dir = File.expand_path '../include_exclude', __FILE__
  Dir.glob(File.join(classes_dir, '*')).each do |f|
    require f
  end

  Tracetree = <<EOS
EOS

  def setup
    @sio = StringIO.new
    @in = /include_exclude\/[mnopq]\.rb/
    @out = [Ignore] + [/p\.rb/]
    @case = -> {O.new.o}
  end

  def test_trace_tree
    rt = binding.trace_tree(@sio, color: false, in: @in, out: @out, &@case)
    assert_equal ReturnValue, rt

    @sio.rewind
    assert_equal Tracetree, @sio.read
  end

  def test_trace_tree_html
    rt = binding.trace_tree(html: true, tmp: 'include_exclude.html', in: @in, out: @out, &@case)
    assert_equal ReturnValue, rt
  end

  def test_trace_tree_html_full
    rt = binding.trace_tree(html: true, tmp: 'include_exclude_full.html', out: Ignore, &@case)
    assert_equal ReturnValue, rt
  end

end
