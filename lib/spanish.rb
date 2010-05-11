# encoding: utf-8
require "phonology"
require File.expand_path("../spanish/orthography", __FILE__)

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
    def get_sounds(string)
      Orthography.translator.translate(string)
    end

    # Translate the Spanish string to International Phonetic Alphabet.
    # Example:
    #
    #     Spanish.get_ipa("chavo")
    #     # => 't͡ʃaβo
    def get_ipa(string)
      get_sounds(string).map(&:symbol).join
    end

end
