require 'tree_graph'

class TraceTree
  module TreeGraphable

    include TreeGraph

    def label_for_tree_graph
      "#{class_and_method} #{source_location}"
      #"#{defined_class}#{current.call_symbol}#{method_id} #{path} #{lineno}"
      #"#{defined_class} #{method_id} #{path} #{lineno}"
    end

    def children_for_tree_graph
      callees
    end
  end
end
