require 'tree_graph'

class TraceTree
  module TreeGraphable

    include TreeGraph

    def label_for_tree_graph
      "#{class_and_method} #{source_location}"
    end

    def children_for_tree_graph
      callees
    end
  end
end
