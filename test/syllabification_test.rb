# encoding: utf-8
require File.expand_path("../test_helper", __FILE__)

class SyllabificationTest < Test::Unit::TestCase

  include Spanish

  test "should syllabify and apply stree rules to single sound word" do
    sequence = ::Phonology::SoundSequence.new(::Phonology::Sound.new("o"))
    assert Syllabifier.syllabify(sequence).first.stress
  end

  test "should syllabify and apply stree rules to multi sound word" do
    sequence =  Orthography.translator.translate("hola")
    Syllabifier.new(sequence)
  end

end

class SyllableTest < Test::Unit::TestCase

  include Spanish

  test "should add consonant to empty onset" do
    s = Syllable.new
    assert s.onset_wants? Phonology::Sound.new("t")
    assert s.onset_wants? Phonology::Sound.new("l")
    assert s.onset_wants? Phonology::Sound.new("w")
  end

  test "should not add vowel to empty onsent" do
    s = Syllable.new
    assert !s.onset_wants?(Phonology::Sound.new("o"))
  end

  test "can append consonant to onset if liquid" do
    s = Syllable.new
    s.onset << Phonology::Sound.new("t")
    assert s.onset_wants? Phonology::Sound.new("l")
    assert s.onset_wants? Phonology::Sound.new("ɾ")
  end

  test "can append consonant to onset if approximant" do
    s = Syllable.new
    s.onset << Phonology::Sound.new("k")
    assert s.onset_wants? Phonology::Sound.new("w")
  end

  test "can not append sound to onset if non-liquid and non-approximant" do
    s = Syllable.new
    s.onset << Phonology::Sound.new("k")
    assert !s.onset_wants?(Phonology::Sound.new("n"))
    assert !s.onset_wants?(Phonology::Sound.new("r"))
    assert !s.onset_wants?(Phonology::Sound.new("s"))
    assert !s.onset_wants?(Phonology::Sound.new("a"))
  end

end
