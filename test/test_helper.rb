$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trace_tree'
require 'minitest/autorun'

class Minitest::Test
  Ignore = {path: /minitest/}
end
