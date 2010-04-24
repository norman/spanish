require File.expand_path("../test_helper", __FILE__)

class VerbTest < Test::Unit::TestCase

  def setup
    @verb = Verb.new("hablar")
  end

  should "detect root" do
    assert_equal "habl", @verb.root
  end

  should "detect type" do
    assert_equal "ar", @verb.type
  end

  # should "conjugate" do
  #   assert_equal "hablé", @verb.conjugate(:person => :first,
  #     :tense => :future,
  #     :mood  => :indicative
  #   )
  # end

end
