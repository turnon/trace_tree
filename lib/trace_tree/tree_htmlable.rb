require 'tree_html'
require 'cgi'
require 'json'

class TraceTree
  module TreeHtmlable

    include TreeHtml

    DEFAULT_JS = ['group_by_file'].map do |f|
      text = File.read File.expand_path("../#{f}.js", __FILE__)
      {text: text}
    end

    def label_for_tree_html
      "<span class='highlight'>#{CGI::escapeHTML class_and_method}</span> "\
        "#{CGI::escapeHTML source_location}"
    end

    def data_for_tree_html
      {}
    end

    def body_js_for_tree_html
      DEFAULT_JS
    end

    def children_for_tree_html
      callees
    end

    def css_for_tree_html
      '.highlight{color: #a50000;}'
    end
  end
end
