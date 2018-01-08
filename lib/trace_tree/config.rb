require 'yaml'
require 'ostruct'

class TraceTree
  class Config

    DEFAULT = {
      'pp_return_value' => []
    }.freeze

    def self.load
      config = DEFAULT
      custom = File.join ENV['HOME'], '.trace_tree_config'
      if File.exists?(custom) && (hash = YAML.load File.read custom)
        hash.select!{ |k, v| config.include? k }
        config = config.merge hash
      end
      OpenStruct.new config
    end
  end
end
