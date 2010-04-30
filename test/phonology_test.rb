# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class PhonologyTest < Test::Unit::TestCase

  include Spanish

  test "c as s or k" do
    assert_sound "kasa", "casa"
    assert_sound "bisi", "bici"
    assert_sound "fɾanko", "franco"
  end

  test "g as ɣ, g, or x" do
    assert_sound "gustaβo", "gustavo"
    assert_sound "laɣo", "lago"
    assert_sound "ximena", "gimena"
    assert_sound "xeɾman", "germán"
  end

  test "defricitivization" do
    assert_sound "kaldo", "caldo"
    assert_sound "kandaðo", "candado"
  end

  test "y" do
    assert_sound "i", "y"
    assert_sound "kaʒo", "cayó"
    assert_sound "iɣwasu", "yguazú"
    assert_sound "doj", "doy"
  end

  test "voicing" do
    assert_sound "razɣo", "rasgo"
    assert_sound "xazmin", "jazmín"
  end

  test "trilled r and flap r" do
    assert_sound "ropa", "ropa"
    assert_sound "foɾo", "foro"
    assert_sound "foraɾ", "forrar"
  end

  test "q, g and u" do
    assert_sound "ke", "que"
    assert_sound "gwemes", "güemes"
    assert_sound "gera", "guerra"
    assert_sound "giɲo", "guiño"
    assert_sound "pingwino", "pingüino"
  end

  private

  def assert_sound(expected, given)
    assert_equal expected, Phonology.sounds(given).map(&:symbol).join
    assert_equal given, Phonology.sounds(given).map(&:orthography).join
  end

end
