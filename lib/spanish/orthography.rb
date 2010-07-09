# encoding: utf-8
module Spanish
  module Orthography

    extend self

    LETTERS = /ch|ll|ñ|á|é|í|ó|ú|ü|[\w]/

    SCANNER = lambda {|string| string.downcase.scan(/rr|ch|ll|ñ|á|é|í|ó|ú|ü|\w/)}

    SOUNDS = ::Phonology::Inventory.from_ipa(
      "m", "n", "ɲ", "ŋ", "p", "b", "t", "d", "k", "ɡ", "β", "f", "v", "ð", "s",
      "z", "ʒ", "ʝ", "x", "ɣ", "j", "r", "ɾ", "l", "w", "i", "u", "e", "o", "a",
      "θ", "ʎ"
    )

    # Note that unvoiced dental fricative is assumed for "z" (and "c"). This is
    # not out of bias towards Spain, but because it is the most
    # information-rich reading of the orthography. The same applies to the
    # presevation of a distinction between "y" and "ll". Yeísmo and other
    # common phenomena can be derived later with phonological rules.
    RULES = Proc.new {
      vowel = ["a", "á", "e", "é", "i", "í", "o", "ó", "u", "ú", "ü"]
      close_front_vowel = ["i", "e", "í", "é"]
      non_close_front_vowel = vowel - close_front_vowel
      case curr_char
      when "á"  then get(:voiced, :open, :front).hint(:primary_stress)
      when "a"  then get(:voiced, :open, :front)
      when "b"  then get(:voiced, :bilabial, :plosive)
      when "c"  then precedes(close_front_vowel) ? get(:unvoiced, :dental, :fricative) : get(:unvoiced, :velar, :plosive)
      when "ch" then get([:alveolar, :plosive], [:postalveolar, :fricative])
      when "d"  then get(:voiced, :alveolar, :plosive)
      when "é"  then get(:close_mid, :front).hint(:primary_stress)
      when "e"  then get(:close_mid, :front)
      when "f"  then get(:unvoiced, :labiodental, :fricative)
      when "g"  then precedes(close_front_vowel) ? get(:unvoiced, :velar, :fricative) : get(:velar, :plosive, :voiced)
      when "h"  then anticipate {|sound| sound.hint(:syllable_boundary).orthography.insert(0, "h")}
      when "í"  then get(:close, :front).hint(:primary_stress)
      when "i"
        if precedes(vowel - ["i", "í"])
          get(:palatal, :approximant)
        else
          get(:close, :front)
        end
      when "j"  then get(:unvoiced, :velar, :fricative)
      when "k"  then get(:unvoiced, :velar, :plosive)
      when "l"  then get(:alveolar, :lateral_approximant)
      when "ll" then get(:palatal, :lateral_approximant) or get(:voiced, :palatal, :fricative)
      when "m"  then get(:bilabial, :nasal, :voiced)
      when "n"  then get(:alveolar, :nasal)
      when "ñ"  then get(:palatal, :nasal)
      when "ó"  then get(:close_mid, :back).hint(:primary_stress)
      when "o"  then get(:close_mid, :back)
      when "p"  then get(:unvoiced, :bilabial, :plosive)
      when "q"  then get(:unvoiced, :velar, :plosive)
      when "r"  then initial? ? get(:trill) : get(:flap)
      when "rr" then get(:trill)
      when "s"  then get(:unvoiced, :alveolar, :fricative)
      when "t"  then get(:unvoiced, :alveolar, :plosive)
      when "ú"
        if follows("q") or between("g", close_front_vowel)
          orthography.insert(1, "ú") && nil
        else
          get(:close, :back).hint(:primary_stress)
        end
      when "u"
        if follows("q") or between("g", close_front_vowel)
          orthography.insert(1, "u") && nil
        elsif follows(vowel - ["i", "í"]) || precedes(vowel)
          get(:velar, :approximant)
        else
          get(:close, :back)
        end
      when "ü"  then get(:velar, :approximant)
      when "v"  then get(:voiced, :bilabial, :plosive)
      when "w"  then get(:velar, :approximant)
      when "x"
        if initial?
          get(:unvoiced, :velar, :fricative)
        else
          [get(:unvoiced, :velar, :plosive), ::Phonology::Sound.new("s")]
        end

      when "y"
        if initial? && final?
          get(:close, :front)
        elsif final?
          get(:palatal, :approximant)
        elsif precedes(vowel)
          get(:voiced, :palatal, :fricative)
        elsif initial? and !precedes(vowel)
          get(:close, :front)
        elsif !precedes(vowel)
          get(:palatal, :approximant)
        end
      when "z" then get(:unvoiced, :dental, :fricative)
      end
    }

    # Get an instance of Phonology::OrthographyTranslater with scanner and sound
    # inventory set for Spanish.
    def translator
      orth = ::Phonology::OrthographyTranslator.new
      orth.scanner = SCANNER
      orth.sounds  = SOUNDS
      orth.rules   = RULES
      orth
    end
  end
end