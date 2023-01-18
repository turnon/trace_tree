$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trace_tree'
require 'minitest/autorun'
require 'thread'

class Minitest::Test
  Ignore = /minitest/
  RB_VER = RUBY_VERSION.split('.')[0..1].join('.').to_f
end
