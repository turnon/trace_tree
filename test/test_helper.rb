$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trace_tree'
require 'tmpdir'
require 'minitest/autorun'

class Minitest::Test
  def tmp_html_for test
    path = File.join(Dir.tmpdir, 'trace_tree_' + test + '.html')
    File.new path, 'w'
  end

end
