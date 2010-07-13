$KCODE = "U" if RUBY_VERSION < "1.9"
require "rubygems"
require "bundler"
Bundler.setup
require "test/unit"
require File.expand_path("../../lib/spanish", __FILE__)
include Spanish

Test::Unit::TestCase.extend Module.new {
  def test(name, &block)
    define_method("test_#{name.gsub(/[^a-z0-9]/i, "_")}".to_sym, &block)
  end
  alias should test
}
