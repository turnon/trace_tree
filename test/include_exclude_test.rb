require 'test_helper'

class IncludeExcludeTest < Minitest::Test

  classes_dir = File.expand_path '../include_exclude', __FILE__
  Dir.glob(File.join(classes_dir, '*')).each do |f|
    require f
  end

end
