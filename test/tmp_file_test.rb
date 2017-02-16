require 'test_helper'

class TmpFileTest < Minitest::Test

  TimePattern = '\\d{8}_\\d{6}_\\d{3}_'

  def test_true
    f = TraceTree::TmpFile.new true
    re = Regexp.new File.join(Dir.tmpdir,  TimePattern + 'trace_tree.html')
    assert_match re, f.path
  end

  def test_file
    f = TraceTree::TmpFile.new 'abc.txt'
    re = Regexp.new File.join(Dir.tmpdir,  TimePattern + 'abc.txt')
    assert_match re, f.path
  end

  def test_subdir
    f = TraceTree::TmpFile.new ['efg', 'abc.txt']
    re = Regexp.new File.join(Dir.tmpdir,  'efg', TimePattern + 'abc.txt')
    assert_match re, f.path
  end

end
