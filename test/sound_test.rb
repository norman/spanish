# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class Sound < Test::Unit::TestCase

  include Spanish::Phonology

  test "should get sound from symbol" do
    sound = Sound.new("b")
    assert_equal "b", sound.symbol
    assert sound.labial?
    assert sound.stop?
    assert sound.consonantal?
  end

  test "should change symbol for changed features" do
    sound = Sound.new("s")
    sound.add :voiced
    assert_equal "z", sound.symbol
  end

end
