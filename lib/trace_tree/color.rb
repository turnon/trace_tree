class TraceTree
  module Color
    def label_for_tree_graph
      "#{highlight class_and_method} #{source_location}"
    end

    private

    def highlight str
      "\e[1m\e[32m#{str}\e[0m"
    end
  end
end
