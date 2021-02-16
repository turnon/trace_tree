require 'tmpdir'
require 'fileutils'

class TraceTree
  class << self
    def tmp
      Dir.tmpdir
    end
  end

  class TmpFile

    DefaultName = 'trace_tree.html'

    def initialize path, transcode: false
      path = recognize_dir path
      @tmp = custom path
      @transcode = transcode
    end

    def puts *content
      content = content.map{ |c| c.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?') } if @transcode

      File.open @tmp, 'a' do |f|
        f.puts(*content)
      end
    end

    def path
      @tmp
    end

    private

    def recognize_dir path
      case path
      when true
        DefaultName
      when String
        path.split '/'
      else
        path
      end
    end

    def custom path
      path = Array(path).map(&:to_s)
      path[-1] = time + path[-1]
      path = [Dir.tmpdir] + path
      ensure_parent path
      File.join(*path)
    end

    def time
      Time.now.strftime '%Y%m%d_%H%M%S_%L_'
    end

    def ensure_parent path_arr
      dir = path_arr[0..-2]
      FileUtils.mkdir_p File.join(*dir)
    end
  end
end
