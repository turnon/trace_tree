require 'tree_html'

class TraceTree
  module TreeHtmlable

    include TreeHtml

    def label_for_tree_html
      "<span class='highlight'>#{class_and_method}</span> #{source_location}"
    end

    def children_for_tree_html
      callees
    end
  end
end
