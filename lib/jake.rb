module Jake
  VERSION = '0.9.3'
  
  CONFIG_FILE = 'jake.yml'
  HELPER_FILE = 'Jakefile'
  
  def self.build(path, options = {})
    build = Build.new(path, nil, options)
    build.force! if options[:force]
    build.run!
  end
  
  def self.read(path)
    path = File.expand_path(path)
    path = File.file?(path) ? path : ( File.file?("#{path}.js") ? "#{path}.js" : nil )
    path and File.read(path).strip
  end
  
  def self.symbolize_hash(hash, deep = true)
    hash.inject({}) do |output, (key, value)|
      value = Jake.symbolize_hash(value) if deep and value.is_a?(Hash)
      output[(key.to_sym rescue key) || key] = value
      output
    end
  end
  
  class Helper
    attr_accessor :build
    attr_reader :options
    
    def initialize(options = {})
      @options = options
    end
    
    def scope; binding; end
  end
end

require 'erb'

%w(build buildable package bundle).each do |file|
  require File.dirname(__FILE__) + '/jake/' + file
end

def helper(name, &block)
  Jake::Helper.class_eval do
    define_method(name, &block)
  end
end
 
