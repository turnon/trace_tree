require 'tmpdir'
require 'fileutils'

class TraceTree
  class TmpFile

    DefaultName = 'trace_tree.html'

    def initialize path
      @tmp = Dir.tmpdir
      path = DefaultName if path == true
      @tmp = custom path
    end

    def puts *content
      File.open @tmp, 'a' do |f|
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
      ensure_parent path
      File.join *path
    end

    def time
      Time.now.strftime '%Y%m%d_%H%M%S_%L_'
    end

    def ensure_parent path_arr
      dir = path_arr[0..-2]
      FileUtils.mkdir_p File.join *dir
    end
  end
end
