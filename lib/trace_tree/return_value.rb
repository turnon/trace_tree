require 'cgi'
require 'pp'

class TraceTree
  module ReturnValue
    BLANK = ''.freeze

    NEED_PP = (
      if File.exists? (pp_config = File.join(ENV['HOME'], '.trace_tree_pp'))
        IO.readlines(pp_config).map &:strip
      else
        []
      end
    ).freeze

    def data_for_tree_html
      attr_value = ::CGI.escapeHTML return_value._trace_tree_pp(config)
      super.merge!({return: attr_value})
    end

    def self.formatted klass, &block
      klass.send :define_method, :_trace_tree_pp, &block
    end

    formatted BasicObject do |*|
      ::Kernel.instance_method(:to_s).bind(self).call
    end

    formatted Object do |config|
      if self.class.ancestors.any?{ |a| config.pp_return_value.include? a.to_s }
        ::PP.singleline_pp(self, ::TraceTree::ReturnValue::BLANK.dup)
      else
        self.to_s
      end
    end

    formatted Array do |config|
      "[#{self.map{ |e| e._trace_tree_pp(config) }.join(', ')}]"
    end

    formatted Hash do |config|
      pairs = self.map{ |k, v| "#{k._trace_tree_pp(config)}=>#{v._trace_tree_pp(config)}"}
      "{#{pairs.join(', ')}}"
    end

    [ENV.singleton_class, Struct, Range, MatchData,
     Numeric, Symbol, FalseClass, TrueClass, NilClass, Module].each do |klass|
      formatted klass do |*|
        ::PP.singleline_pp(self, ::TraceTree::ReturnValue::BLANK.dup)
      end
    end

  end

  module ConsoleReturnValue
    include ReturnValue

    JS = File.read File.expand_path('../native_console.js', __FILE__)

    def body_js_for_tree_html
      super + [{text: JS}]
    end
  end

  module LuxuryReturnValue
    include ReturnValue

    JS = File.read File.expand_path('../console.js', __FILE__)
    CSS = File.read File.expand_path('../console.css', __FILE__)

    def css_for_tree_html
      super + CSS
    end

    def body_js_for_tree_html
      super + [{text: JS}]
    end
  end
end
