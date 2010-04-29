# encoding: utf-8
module Spanish

  module Syllabification

    CONSONANT_CLUSTER = /[b|c|f|g|p][l|r]|ch|dr|ll|qu|rr|tr/
    DIPTHONG          = /u[a|á|e|é|i|í]|i[a|á|e|é|u|ú]|ü[i|í|e|é]/
    VOWEL             = /a|á|e|é|i|í|o|ó|u|ú|ü/
    UNACCENTED_VOWEL  = /a|e|i|o|u/
    LIQUID            = /l|r/
    OBSTRUENT         = /|b|ch|d|t|d/
    STRONG_UNACCENTED_VOWEL      = /a|e|o/
    APPROXIMANT = /b|l|r|d|s|g||n|m|v|x|y|z/

    # An array of syllables
    def syllables
      iterator = SyllableIterator.new(string)
      iterator.entries
    end

    private

    def string
      self
    end


    class SyllableIterator < Enumerator

      SYLLABLE_START = 0
      SYLLABLE_CONT = 1
      SYLLABLE_END = 2

      attr :letters
      attr :syllables
      attr :current_syllable
      attr :state

      def initialize(word)
        # treat "rr" as a separate letter
        @letters = word.scan(/rr|ch|ll|á|é|í|ó|ú|ü|ñ|[\w]/)
        @syllables = []
        @current_syllable = []
      end

      private

      def each
        @state = SYLLABLE_START
        while letters.size > 0 do
          case @state
          when SYLLABLE_START
            @current_syllable << @letters.shift
            @state = SYLLABLE_CONT
          when SYLLABLE_END
            yield @current_syllable.join
            @current_syllable = []
            @state = SYLLABLE_START
          when SYLLABLE_CONT
            if break?
              yield @current_syllable.join
              @current_syllable = [@letters.shift]
            else
              @current_syllable << @letters.shift
              @state = SYLLABLE_END if break?
            end
          end
        end
        yield @current_syllable.join
      end

      def last_letter
        @current_syllable.last
      end

      def next_letter
        @letters.first
      end

      def break?
        # Dirty hack to allow some morphological breaks. Don't complain. The
        # crossover between phonology and morphology itself is a dirty hack to
        # begin with.
        if ["des", "sub"].include? "#{@current_syllable.join}#{next_letter}"
          @current_syllable << @letters.shift
          return true
        end
        # always break at "h"
        return true if next_letter == "h"
        # allow consonants at end of words
        return false if !(next_letter =~ VOWEL || @letters[1])
        # accented vowels
        return true if last_letter =~ /a|e|o/ && next_letter =~ /á|é|í|ó|ú/
        return true if last_letter =~ /é|í|ó|ú/ && next_letter =~ /a|e|o|/
        # these consonants usually can't end a syllable
        # return false if next_letter =~ /t|v/ && (@letters[1] && @letters[1] =~ /n/)
        return true if next_letter =~ /b|c|f|g|h|j|k|p|q|rr|t|w/
        # adjacent strong vowels
        return true if last_letter =~ /a|e|o/ && next_letter =~ /a|e|o/
        # split other consonant clusters
        return true  if !last_letter =~ VOWEL && !next_letter =~ VOWEL
        # don't allow vowel-approximant if followed by vowel
        return true if next_letter =~ APPROXIMANT && (last_letter =~ VOWEL && @letters[1] =~ VOWEL)
        # break at liquid or nasal followed by any consonant
        return true if (last_letter =~ /l|r|n|m/) && !(next_letter =~ VOWEL)
        # break at consonant followed by nasal
        # return true if last_letter =~ /b|t|v/ && next_letter =~ /m|n/
        false
      end

    end

  end

end
