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

  test "should get sound from features" do
    sound = Sound.new(:labial, :stop)
    assert_equal "p", sound.symbol
  end

  test "should change symbol for added features" do
    sound = Sound.new("s")
    sound << :voiced
    assert_equal "z", sound.symbol
  end


end
