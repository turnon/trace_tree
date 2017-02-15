require 'tree_graph'

class TraceTree
  module TreeGraphable

    include TreeGraph

    def parent_for_tree_graph
      parent
    end

    def is_last_for_tree_graph
      return true unless parent
      parent.callees.index(self) == (parent.callees.count - 1)
    end

    def label_for_tree_graph
      "#{class_and_method} #{source_location}"
    end

    def children_for_tree_graph
      callees
    end
  end
end
