# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class PhonologyTest < Test::Unit::TestCase

  include Spanish

  test "c as s or k" do
    assert_sound "kasa", "casa"
    assert_sound "bisi", "bici"
    assert_sound "franko", "franco"
  end

  test "g as G, g, or x" do
    assert_sound "gustaBo", "gustavo"
    assert_sound "laGo", "lago"
    assert_sound "ximena", "gimena"
    assert_sound "xerman", "germán"
  end

  test "fricativization" do
    assert_sound "kaDa", "cada"
    assert_sound "djente", "diente"
    assert_sound "laGo", "lago"
    assert_sound "gazo", "gallo"
    assert_sound "kaBo", "cabo"
    assert_sound "beo", "veo"
  end

  test "y" do
    assert_sound "i", "y"
    assert_sound "kazo", "cayó"
    assert_sound "iGwasu", "yguazú"
  end

  test "voicing" do
    assert_sound "RazGo", "rasgo"
  end

  test "trilled r and flap r" do
    assert_sound "Ropa", "ropa"
    assert_sound "foro", "foro"
    assert_sound "foRar", "forrar"
  end

  test "q, g and u" do
    assert_sound "ke", "que"
    assert_sound "gwemes", "güemes"
    assert_sound "geRa", "guerra"
    assert_sound "giño", "guiño"
    assert_sound "pingwino", "pingüino"
  end

  private

  def assert_sound(expected, given)
    assert_equal expected, Phonology.sounds(given).map {|s| s[0]}.compact.join
    assert_equal given, Phonology.sounds(given).map {|s| s[1]}.compact.join
  end

end
