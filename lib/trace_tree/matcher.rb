class TraceTree
  class Matcher
    def initialize opt=nil
      opt = {} if opt.nil?
      @paths = Array opt[:path]
      @modules = Array opt[:type]
    end

    def no_criteria?
      @paths.empty? && @modules.empty?
    end

    def match? point
      @paths.any?{ |path| path =~ point.path } ||
        @modules.any?{ |mod| mod >= point.defined_class }
    end

    class Include < Matcher
      def match? point
        return true if no_criteria?
        super
      end
    end

    class Exclude < Matcher
      def match? point
        return false if no_criteria?
        super
      end
    end

  end
end
