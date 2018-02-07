class TraceTree
  module Args
    def data_for_tree_html
      super.merge!({args: ::JSON.generate(arguments)})
    end
  end
end
