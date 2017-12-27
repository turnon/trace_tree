class TraceTree
  module ReturnValue

    SHOW_RT = <<-JS
TreeHtml.hover_press('r', function(n){
  var a = n.querySelector('a');
  console.log('>', a.querySelector('span').innerText + "\\n" + a.getAttribute('data-return'));
});
JS
    def data_for_tree_html
      super.merge!({return: ::JSON.generate([return_value])})
    end

    def body_js_for_tree_html
      super.push({text: SHOW_RT})
    end
  end
end
