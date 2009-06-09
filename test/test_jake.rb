require "test/unit"
require "jake"
require "fileutils"
require "find"

DIR = File.dirname(__FILE__)

class TestJake < Test::Unit::TestCase
  def setup
    FileUtils.rm_rf(File.join(DIR, 'output'))
  end
  
  def test_build
    Jake.build(DIR)
    expected = File.join(DIR, 'expected')
    actual   = File.join(DIR, 'output')
    Find.find(expected) do |path|
      next unless File.file?(path)
      assert_equal File.read(path).strip, File.read(actual + path.gsub(expected, ''))
    end
  end
end

