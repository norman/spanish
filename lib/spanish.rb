# encoding: utf-8
require "phonology"
require File.expand_path("../spanish/orthography", __FILE__)
require File.expand_path("../spanish/phonology", __FILE__)
require File.expand_path("../spanish/syllable", __FILE__)

# This library provides some linguistic and orthographic tools for Spanish
# words.
module Spanish

  extend self

  # Returns an array of Spanish letters from string.
  # Example:
  #     Spanish.letters("chillar")
  #     # => ["ch", "i", "ll", "a", "r"]
  def letters(string)
    string.scan(Orthography::LETTERS)
  end

  # Get an array of Phonology::Sounds from the string.
  def get_sounds(string, *rules)
    sequence = Orthography.translator.translate(string)
    Syllabifier.syllabify(sequence)
    Phonology.general_rules.values.each do |rule|
      rule.apply(sequence)
    end
    rules.each do |rule|
      Phonology.optional_rules[rule.to_sym].apply(sequence)
    end
    sequence
  end

  # Translate the Spanish string to International Phonetic Alphabet.
  # Example:
  #
  #     Spanish.get_ipa("chavo")
  #     # => 't͡ʃaβo
  def get_ipa(string, *rules)
    get_sounds(string, *rules).to_s
  end

  def get_syllables(string, *rules)
    get_sounds(string, *rules).map(&:syllable).uniq
  end

  def get_syllables_ipa(string, *rules)
    syllables = get_syllables(string, *rules)
    syllables.map {|s| syllables.length == 1 ? s.to_s(false) : s.to_s }.join(" ")
  end
end
