require 'tree_html'
require 'cgi'

class TraceTree
  module TreeHtmlable

    include TreeHtml

    def label_for_tree_html
      "<span class='highlight'>#{CGI::escapeHTML class_and_method}</span> #{CGI::escapeHTML source_location}"
    end

    def children_for_tree_html
      callees
    end

    def css_for_tree_html
      '.highlight{color: #a50000;}'
    end
  end
end
