# encoding: utf-8
module Spanish

  module Phonology


    class Sound

      @@inventory = ::Linguistics::Phonology::SoundInventory.new(
        "i", "u", "e", "o", "a", "j", "w", "m", "n", "ɲ", "ŋ", "b", "d", "ʝ",
        "g", "β", "ð", "z", "ʒ", "ɣ", "r", "ɾ", "l", "ʎ", "p", "t", "ʧ", "k",
        "f", "θ", "s", "x"
      )

      attr :feature_bits
      attr_accessor :orthography

      def initialize(*args)
        @feature_bits = @@inventory.mask(*args)
      end

      @@inventory.class.features.each do |name, bits|
        class_eval(<<-EOM)
          def #{name}?
            @feature_bits & @@inventory.class.features[:#{name}] != 0
          end
        EOM
      end

      def vocalic?
        @feature_bits >= @@inventory.class.features[:high]
      end

      def consonantal?
        !vocalic?
      end

      def symbol
        @@inventory.symbol @feature_bits
      end

      def add(*features)
        @feature_bits |= @@inventory.mask(features)
        self
      end
      alias << add

      def del(*features)
        @feature_bits &= ~@@inventory.mask(features)
        self
      end
      alias >> del

      # Replace `to_del` with `to_add`
      def swap(to_del, to_add)
        add *to_add
        del *to_del
      end

    end

    extend self

    attr_reader :sonorities
    attr_reader :sounds


    SEQUENCES = /qu|
      gue|gui|güi|güe|ge|gi|gué|guí|güí|güé|gé|gí|
      ua|ui|ue|uo|
      ci|ce|
      rr|ch|ll|
      á|é|í|ó|ú|ü|ñ|
      [\w]/xu

    @approximations = {
      "b"   => "β",
      "c"   => "k",
      "ce"  => ["s", "e"],
      "ch"  => "c",
      "ci"  => ["s", "i"],
      "cé"  => ["s", "e"],
      "cí"  => ["s", "i"],
      "d"   => "ð",
      "g"   => "ɣ",
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
      "ll"  => "ʒ",
      "q"   => "k",
      "qu"  => ["k", nil],
      "r"   => "ɾ",
      "rr"  => "r",
      "ua"  => ["w", "a"],
      "ue"  => ["w", "e"],
      "ui"  => ["w", "i"],
      "uo"  => ["w", "o"],
      "v"   => "β",
      "z"   => "s",
      "ñ"   => "ɲ",
      "üe"  => ["w", "e"],
      "üi"  => ["w", "i"],
      "y"   => "j"
    }

    def sounds(string)
      sounds = []
      sound = nil
      sequences = string.scan(SEQUENCES)
      sequences.each do |seq|
        if approx = @approximations[seq]
          if approx.kind_of?(Array)
            [approx, seq.split('')].transpose.each do |s, o|
              if s == nil
                sound.orthography << o
              else
                sound = Sound.new(s)
                sound.orthography = o
                sounds << sound
              end
            end
          else
            sound = Sound.new(approx)
            sound.orthography = seq
            sounds << sound
          end
        else
          sound = Sound.new(strip_diacritic(seq))
          sound.orthography = seq
          sounds << sound
        end
      end
      apply_rules(sounds)
    end

    def apply_rules(sounds)
      max = sounds.length
      sounds.each_index do |i|

        prv = sounds[i-1] if i > 0
        nex = sounds[i+1] if i < max
        cur = sounds[i]

        if cur.symbol == "j"
          # "y" to "i"
          if (!prv && !nex) || ((!prv || prv && !prv.vocalic?) && nex && !nex.vocalic?)
            cur.swap([:palatal, :approximant], [:high, :front])
          end
          # rioplatense "y"
          cur.swap(:approximant, :fricative) if nex && nex.vocalic?
        end

        # word-initial "r"
        cur.swap(:flap, :trill) if cur.symbol == "ɾ" && !prv

        # defricativization
        if cur.voiced? && cur.fricative? && (cur.labial? || cur.dental? || cur.velar?)
          cur.swap(:fricative, :stop) if (!prv || prv.nasal?)
          cur.swap(:fricative, :stop) if (cur.dental? && prv && prv.lateral?)
        end

        # voicing
        if cur.fricative? && cur.alveolar? && nex && nex.consonantal? && nex.voiced?
          cur << :voiced
        end

      end
      sounds
    end

    private

    def strip_diacritic(letter)
      approximations = {
        "á" => "a",
        "é" => "e",
        "í" => "i",
        "ó" => "o",
        "ú" => "u",
        "ü" => "u"
      }
      approximations[letter] or letter
    end

  end

end
