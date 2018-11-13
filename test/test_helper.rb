$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trace_tree'
require 'minitest/autorun'
require 'thread'

class Minitest::Test
  Ignore = /minitest/

  [:zero, :one, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten].each_with_index do |name, i|
    class_eval "def #{name}() #{i} end", __FILE__, __LINE__
  end
end
