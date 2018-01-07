require 'cgi'
require 'pp'

class TraceTree
  module ReturnValue

    SHOW_RT = <<-JS
TreeHtml.hover_press('r', function(n){
  var a = n.querySelector('a');
  console.log('>', a.querySelector('span').innerText + "\\n" + a.getAttribute('data-return'));
});
JS

    BLANK = ''.freeze

    NEED_PP = (
      if File.exists? (pp_config = File.join(ENV['HOME'], '.trace_tree_pp'))
        IO.readlines(pp_config).map &:strip
      else
        []
      end
    ).freeze

    def data_for_tree_html
      super.merge!({return: ::CGI.escapeHTML(return_value._trace_tree_pp)})
    end

    def body_js_for_tree_html
      super.push({text: SHOW_RT})
    end

    def self.formatted klass, &block
      klass.send :define_method, :_trace_tree_pp, &block
    end

    formatted BasicObject do
      ::Kernel.instance_method(:to_s).bind(self).call
    end

    formatted Object do
      if self.class.ancestors.any?{ |a| ::TraceTree::ReturnValue::NEED_PP.include? a.to_s }
        ::PP.singleline_pp(self, ::TraceTree::ReturnValue::BLANK.dup)
      else
        self.to_s
      end
    end

    formatted Array do
      "[#{self.map{ |e| e._trace_tree_pp }.join(', ')}]"
    end

    formatted Hash do
      pairs = self.map{ |k, v| "#{k._trace_tree_pp}=>#{v._trace_tree_pp}"}
      "{#{pairs.join(', ')}}"
    end

    [ENV.singleton_class, Struct, Range, MatchData,
     Numeric, Symbol, FalseClass, TrueClass, NilClass, Module].each do |klass|
      formatted klass do
        ::PP.singleline_pp(self, ::TraceTree::ReturnValue::BLANK.dup)
      end
    end

  end
end
