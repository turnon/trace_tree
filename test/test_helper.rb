$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trace_tree'
require 'minitest/autorun'
require 'thread'

class Minitest::Test
  Ignore = /minitest/
end
