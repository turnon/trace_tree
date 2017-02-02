require "trace_tree/version"
require 'binding_of_callers'

class TraceTree

  module Node

    def location bi
      bi.inspect.gsub(/#<Binding:\d+\s(.*):\d+>/, '\1')
    end

    extend self
  end
end

class Binding
  def trace_tree &b
    tp = TracePoint.trace(:call)do |tp|
      p tp
      #tp.binding.pry
    end
    eval('self').instance_eval &b
  ensure
    tp.disable
  end
end
