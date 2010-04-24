require "test/unit"
require File.expand_path("../../lib/spanish_verbs", __FILE__)

include SpanishVerbs

Test::Unit::TestCase.extend Module.new {
  def test(name, &block)
    define_method("test_#{name.gsub(/[^a-z0-9]/i, "_")}".to_sym, &block)
  end
  alias should test
}
