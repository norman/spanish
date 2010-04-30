# encoding: utf-8
require "unicode"
module Spanish

  module Phonology

    class Sound

      FEATURES = {
        :voiced      => 1 << 0,
        :nasal       => 1 << 1,
        :stop        => 1 << 2,
        :fricative   => 1 << 3,
        :trill       => 1 << 4,
        :flap        => 1 << 5,
        :lateral     => 1 << 6,
        :labial      => 1 << 7,
        :dental      => 1 << 8,
        :alveolar    => 1 << 9,
        :palatal     => 1 << 10,
        :velar       => 1 << 11,
        :high        => 1 << 12,
        :mid         => 1 << 13,
        :low         => 1 << 14,
        :front       => 1 << 15,
        :back        => 1 << 16,
        :round       => 1 << 17,
        :approximant => 1 << 18
      }

      FEATURES.each do |name, bits|
        class_eval(<<-EOM)
          def #{name.to_s}?
            @feature_bits & FEATURES[:#{name}] != 0
          end
        EOM
      end

      SOUNDS = {
        "i" => [:voiced, :high, :front],
        "u" => [:voiced, :high, :back],
        "e" => [:voiced, :mid, :front],
        "o" => [:voiced, :mid, :back, :round],
        "a" => [:voiced, :low, :back],

        "j" => [:voiced, :palatal, :approximant],
        "w" => [:voiced, :labial, :velar, :approximant],

        "m" => [:voiced, :nasal, :labial],
        "n" => [:voiced, :nasal, :alveolar],
        "ɲ" => [:voiced, :nasal, :palatal],
        "ŋ" => [:voiced, :nasal, :velar],

        "b" => [:voiced, :labial, :stop],
        "d" => [:voiced, :dental, :stop],
        "ʝ" => [:voiced, :palatal, :stop],
        "g" => [:voiced, :velar, :stop],

        "β" => [:voiced, :labial, :fricative],
        "ð" => [:voiced, :dental, :fricative],
        "z" => [:voiced, :alveolar, :fricative],
        "ʒ" => [:voiced, :palatal, :fricative],
        "ɣ" => [:voiced, :velar, :fricative],

        "r" => [:voiced, :alveolar, :trill],

        "ɾ" => [:voiced, :alveolar, :flap],

        "l" => [:voiced, :alveolar, :lateral],
        "ʎ" => [:voiced, :palatal, :lateral],

        "p" => [:labial, :stop],
        "t" => [:dental, :stop],
        "ʧ" => [:palatal, :stop],
        "k" => [:velar, :stop],

        "f" => [:labial, :fricative],
        "θ" => [:dental, :fricative],
        "s" => [:alveolar, :fricative],
        "x" => [:velar, :fricative]
      }

      def self.feature_matrix(args)
        args.inject(0) {|memo, object| memo += FEATURES[object]}
      end

      FEATURE_MAP = Hash[SOUNDS.map {|letter, features| [letter, feature_matrix(features)]}]

      def initialize(*args)
        @feature_bits = 0
        if args.size == 1 && args.first.kind_of?(String)
          args = SOUNDS[args.shift]
        end
        args.each {|a| add a}
      end

      def vocalic?
        high? || mid? || low?
      end

      def consonantal?
        !vocalic?
      end

      def symbol
        FEATURE_MAP.key @feature_bits
      end

      def add(symbol)
        @feature_bits += FEATURES[symbol.to_sym]
      end

      def sub(symbol)
        @feature_bits -= FEATURES[symbol.to_sym]
      end

    end

    extend self

    attr_reader :sonorities
    attr_reader :sounds


    def feature_matrix(*args)
    end



    SEQUENCES = /qu|
      gue|gui|güi|güe|ge|gi|gué|guí|güí|güé|gé|gí|
      rr|ch|ll|
      á|é|í|ó|ú|ü|ñ|
      [\w]/xu

    @approximations = {
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
