# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class PhonologyTest < Test::Unit::TestCase

  test "c as s or k" do
    assert_sound "kasa", "casa"
    assert_sound "biθi", "bici"
    assert_sound "fɾanko", "franco"
  end

  test "x" do
    assert_sound "eksamen", "examen"
  end

  test "g as ɣ, g, or x" do
    assert_sound "ɡustaβo", "gustavo"
    assert_sound "laɣo", "lago"
    assert_sound "ximena", "gimena"
    assert_sound "xeɾman", "germán"
  end

  test "sprirantization" do
    assert_sound "alɣo", "algo"
    assert_sound "ranɡo", "rango"
    assert_sound "kaldo", "caldo"
    assert_sound "kandaðo", "candado"
  end

  test "y" do
    assert_sound "i", "y"
    assert_sound "kaʝo", "cayó"
    assert_sound "iɣwaθu", "yguazú"
    assert_sound "doj", "doy"
  end

  test "voicing" do
    assert_sound "rasɣo", "rasgo"
    assert_sound "xaθmin", "jazmín"
  end

  test "trilled r and flap r" do
    assert_sound "ropa", "ropa"
    assert_sound "foɾo", "foro"
    assert_sound "foraɾ", "forrar"
  end

  test "q, g and u" do
    assert_sound "ke", "que"
    assert_sound "ɡwemes", "güemes"
    assert_sound "ɡera", "guerra"
    assert_sound "ɡiɲo", "guiño"
    assert_sound "pinɡwino", "pingüino"
  end

  test "word-initial ps" do
    assert_sound "sikoloxia", "psicología"
  end

  test "x archaism" do
    assert_sound "mexiko", "México"
    assert_sound "eksmexikano", "exmexicano"
    assert_sound "kixote", "Quixote"
    assert_sound "kixotesko", "quixotesco"
  end

  test "diphthongs" do
    assert_sound "buo", "buho"
    assert_sound "pua", "púa"
    assert_sound "oeste",  "oeste"
  end

  private

  def assert_sound(expected, given)
    assert_equal expected, Spanish.get_ipa(given)
    assert_equal given.downcase, Spanish.get_sounds(given).map(&:orthography).join
  end

end
