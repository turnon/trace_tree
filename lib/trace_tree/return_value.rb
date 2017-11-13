class TraceTree
  module ReturnValue
    def data_for_tree_html
      super.merge!({return: ::JSON.generate([return_value])})
    end
  end
end
