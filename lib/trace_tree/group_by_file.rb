class TraceTree
  module GroupByFile

    class FilePoint
      attr_reader :callees, :source_location

      def initialize(callees)
        @source_location = callees[0].path
        @callees = callees
      end

      include TreeGraph

      def label_for_tree_graph
        "@ #{source_location}"
      end

      def children_for_tree_graph
        callees
      end

      include TreeHtml

      def label_for_tree_html
        "#{CGI::escapeHTML source_location}"
      end

      def children_for_tree_html
        callees
      end
    end

    def group_by_file!
      stack = [self]
      popped = nil

      while !stack.empty?
        top = stack[-1]
        if top.callees.empty? || top.callees.include?(popped)
          (popped = stack.pop)._group_by_file
        else
          stack.concat top.callees
        end
      end

      self
    end

    def _group_by_file
      return if callees.empty?

      last_path = nil
      group_by_path = []

      callees.each do |ee|
        if last_path != ee.path
          last_path = ee.path
          group_by_path << []
        end

        group_by_path[-1] << ee
      end

      return if group_by_path.size == 1 && callees[0].path == path

      group_by_path.map!{ |ees| FilePoint.new(ees) }
      @callees = group_by_path
    end

  end
end
