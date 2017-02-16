require 'tmpdir'

class TraceTree
  class TmpFile

    DefaultName = 'trace_tree.html'

    def initialize path
      @tmp = Dir.tmpdir
      path = DefaultName if path == true
      @tmp = custom path
    end

    def puts *content
      File.open @tmp, 'w' do |f|
        f.puts *content
      end
    end

    def path
      @tmp
    end

    private

    def custom path
      path = Array(path).map(&:to_s)
      path[-1] = time + path[-1]
      path = [@tmp] + path
      File.join *path
    end

    def time
      Time.now.strftime '%Y%m%d_%H%M%S_%L_'
    end
  end
end
