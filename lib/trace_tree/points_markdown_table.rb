class TraceTree
  class PointsMarkdownTable
    HEADERS = [:event, :defined_class, :method_id, :frame_env, :path, :lineno, :thread, :return_value]
    COL_SEPERATOR = '|'
    HEADER_BOTTOM = '-'
    NEWLINE = "\n"
    RETURN = /return/

    LT_RAW = /</
    LT_ESC = '&lt;'
    GT_RAW= />/
    GT_ESC = '&gt;'
    COL_RAW = '|'
    COL_ESC = '&#124;'

    def initialize(points)
      @points = points
    end

    def to_s
      @buffer = []
      generate_headers
      generate_rows
      @buffer.join
    end

    def generate_headers
      HEADERS.each{ |h| @buffer << COL_SEPERATOR << h }
      @buffer << COL_SEPERATOR
      @buffer << NEWLINE
      HEADERS.each{ |h| @buffer << COL_SEPERATOR << HEADER_BOTTOM }
      end_row
    end

    def generate_rows
      @points.each do |point|
        point_to_row(point.event)
        point_to_row(point.defined_class)
        point_to_row(point.method_id)
        point_to_row(point.thread? ? nil : point.frame_env)
        point_to_row(point.path)
        point_to_row(point.lineno)
        point_to_row(point.thread)
        point_to_row(point.event =~ RETURN ? point.return_value : nil)
        end_row
      end
    end

    def end_row
      @buffer << COL_SEPERATOR << NEWLINE
    end

    def point_to_row(info)
      info = info.to_s.gsub(LT_RAW, LT_ESC)
      info.gsub!(GT_RAW, GT_ESC)
      info.gsub!(COL_RAW, COL_ESC)
      @buffer << COL_SEPERATOR << info
    end
  end
end
