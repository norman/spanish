# encoding: utf-8
require "unicode"
module Spanish

  module Phonology

    extend self

    attr_reader :sonorities
    attr_reader :sounds

    SEQUENCES = /gue|gui|güi|güe|ge|gi|gué|guí|güí|güé|gé|gí|
      ci|cí|ce|cé|
      qu|rr|ch|ll|
      ai|au|ie|io|ua|ue|üe|ui|üi|uo|
      á|é|í|ó|ú|ü|ñ|
      [\w]/xu

    VOWEL    = /a|e|i|o|u/
    VOICED   = /b|B|d|D|G|g|l|m|n|r|R|z|j|v|w|a|e|i|o|u/
    CONSONANT = /b|B|c|d|f|g|G|k|l|m|n|p|r|R|s|t|v|x|z/
    NASAL    = /m|n/
    UNVOICED = /k|s|f|t|p|x/

    # "R" = trilled "r", "r" = flap
    # "B" = fricative, "b" = stop
    # "D" = fricative, "d" = stop
    # "G" = fricative, "g" = stop
    # "c" = palatal ("ch")
    # "z" = fricative (Rioplatense "ll")
    # "j" = glide
    @sonorities = {
      0 => ["b", "c", "d", "D", "f", "g", "G", "k", "p", "R", "s", "t", "x", "z"],
      1 => ["l", "r"],
      2 => ["n", "ñ", "m"],
      3 => ["j", "w"],
      4 => ["a", "e", "i", "o", "u"]
    }

    @sounds = Hash[*sonorities.map {|s, g| g.map {|c| [c, s]}}.flatten]

    @approximations = {
      "ai"  => ["a", "j"],
      "au"  => ["a", "w"],
      "b"   => "B",
      "c"   => "k",
      "ce"  => ["s", "e"],
      "ch"  => "c",
      "ci"  => ["s", "i"],
      "cé"  => ["s", "e"],
      "cí"  => ["s", "i"],
      "d"   => "D",
      "g"   => "G",
      "gue" => ["g", nil, "e"],
      "gui" => ["g", nil, "i"],
      "güi" => ["g", "w", "i"],
      "güe" => ["g", "w", "e"],
      "ge"  => ["x", "e"],
      "gi"  => ["x", "i"],
      "gué" => ["g", nil, "e"],
      "guí" => ["g", nil, "i"],
      "güí" => ["g", "w", "i"],
      "güé" => ["g", "w", "e"],
      "gé"  => ["x", "e"],
      "gí"  => ["x", "i"],
      "ie"  => ["j", "e"],
      "io"  => ["j", "o"],
      "j"   => "x",
      "ll"  => "z",
      "q"   => "q",
      "qu"  => ["k", nil],
      "rr"  => "R",
      "ua"  => ["w", "a"],
      "ue"  => ["w", "e"],
      "ui"  => ["w", "i"],
      "uo"  => ["w", "o"],
      "v"   => "B",
      "z"   => "s",
      "ñ"   => "ñ",
      "üe"  => ["w", "e"],
      "üi"  => ["w", "i"],
    }

    def sounds(string)
      sequences = string.scan(SEQUENCES)
      sounds = []
      sequences.each_with_index do |seq, index|
        if approx = @approximations[seq]
          if approx.kind_of?(Array)
            sounds += [approx, seq.split('')].transpose
          else
            sounds << [approx, seq]
          end
        else
          sounds << [strip_diacritic(seq), seq]
        end
      end
      apply_rules(sounds)
    end

    private

    def apply_rules(sounds)
      max = sounds.length
      sounds.each_index do |i|
        prv = i > 0 ? sounds[i-1] : nil
        nex = i < max ? sounds[i+1] : nil
        cur = sounds[i]

        # othorgraphic rules for "y"
        if cur[0] == "y"
          if nex && nex[0] =~ VOWEL
            # @TODO don't assume Rioplatense
            cur[0] = "z"
          else
            cur[0] = "i"
          end
        end

        # word-initial "r"
        cur[0] = "R" if i == 0 && cur[0] == "r"

        # defricativization
        if !prv || prv[0] =~ NASAL
          case cur[0]
          when "B" then cur[0] = "b"
          when "G" then cur[0] = "g"
          when "D" then cur[0] = "d"
          end
        elsif prv && prv[0] =~ /l/
          cur[0] = "d" if cur[0] == "D"
        end

        # voicing
        if cur[0] == "s" && nex && nex[0] =~ /g|G|d|D|m|n/
          cur[0] = "z"
        end

      end
      sounds
    end

    def strip_diacritic(string)
      Unicode.normalize_KD(string).gsub(/[^\x00-\x7f]/, '')
    end


  end

end
