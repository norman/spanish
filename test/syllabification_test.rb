# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class SyllabificationTest < Test::Unit::TestCase

  include Phonology
  include Spanish

  test "should add consonant to empty onset" do
    s = Syllable.new
    assert s.onset_wants? Sound.new("t")
    assert s.onset_wants? Sound.new("l")
    assert s.onset_wants? Sound.new("w")
  end

  test "should not add vowel to empty onsent" do
    s = Syllable.new
    assert !s.onset_wants?(Sound.new("o"))
  end

  test "can append consonant to onset if liquid" do
    s = Syllable.new
    s.onset << Sound.new("t")
    assert s.onset_wants? Sound.new("l")
    assert s.onset_wants? Sound.new("ɾ")
  end

  test "can append consonant to onset if approximant" do
    s = Syllable.new
    s.onset << Sound.new("k")
    assert s.onset_wants? Sound.new("w")
  end

  test "can not append sound to onset if non-liquid and non-approximant" do
    s = Syllable.new
    s.onset << Sound.new("k")
    assert !s.onset_wants?(Sound.new("n"))
    assert !s.onset_wants?(Sound.new("r"))
    assert !s.onset_wants?(Sound.new("s"))
    assert !s.onset_wants?(Sound.new("a"))
  end

end
