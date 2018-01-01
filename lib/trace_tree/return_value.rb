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
      super.merge!({return: formatted_return_value})
    end

    def body_js_for_tree_html
      super.push({text: SHOW_RT})
    end

    private

    def formatted_return_value
      klass = ::Kernel.instance_method(:class).bind(return_value).call
      value =
        if klass <= Object && klass.ancestors.any?{ |a| NEED_PP.include? a.to_s }
          ::PP.singleline_pp(return_value, BLANK.dup)
        else
          ::Kernel.instance_method(:to_s).bind(return_value).call
        end
      ::CGI.escapeHTML value
    end

  end
end
