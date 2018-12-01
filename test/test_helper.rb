require 'trace_tree'
require 'minitest/autorun'
require 'thread'

class Minitest::Test
  Ignore = /minitest/
  Lib = File.expand_path('../../lib', __FILE__)
  $LOAD_PATH.unshift Lib
end
