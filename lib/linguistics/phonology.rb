# encoding: utf-8
module Linguistics

  module Phonology

    class SoundInventory

      @@features = {
        :voiced      => 1 << 0,
        :stop        => 1 << 1,
        :trill       => 1 << 2,
        :fricative   => 1 << 3,
        :flap        => 1 << 4,
        :lateral     => 1 << 5,
        :nasal       => 1 << 6,
        # point of articulation
        :labial      => 1 << 7,
        :dental      => 1 << 8,
        :alveolar    => 1 << 9,
        :palatal     => 1 << 10,
        :velar       => 1 << 11,
        :approximant => 1 << 12,
        # vocalic features
        :high        => 1 << 13,
        :front       => 1 << 14,
        :mid         => 1 << 15,
        :low         => 1 << 16,
        :back        => 1 << 17
      }

      # Note that at the moment, only symbols used in Spanish are here; this
      # library is being developed for Spanish, but I'm keeping this in a
      # separate library to allow reuse.
      @@symbols = {
        "i" => [:voiced, :high, :front],
        "u" => [:voiced, :high, :back],
        "e" => [:voiced, :mid, :front],
        "o" => [:voiced, :mid, :back],
        "a" => [:voiced, :low, :back],
        "j" => [:voiced, :palatal, :approximant],
        "w" => [:voiced, :labial, :velar, :approximant],
        "m" => [:voiced, :nasal, :labial],
        "n" => [:voiced, :nasal, :alveolar],
        "ɲ" => [:voiced, :nasal, :palatal],
        "ŋ" => [:voiced, :nasal, :velar],
        "b" => [:voiced, :stop, :labial],
        "d" => [:voiced, :stop, :dental],
        "ʝ" => [:voiced, :stop, :palatal],
        "g" => [:voiced, :stop, :velar],
        "β" => [:voiced, :fricative, :labial],
        "ð" => [:voiced, :fricative, :dental],
        "z" => [:voiced, :fricative, :alveolar],
        "ʒ" => [:voiced, :fricative, :palatal],
        "ɣ" => [:voiced, :fricative, :velar],
        "r" => [:voiced, :trill, :alveolar],
        "ɾ" => [:voiced, :flap, :alveolar],
        "l" => [:voiced, :lateral, :alveolar],
        "ʎ" => [:voiced, :lateral, :palatal],
        "p" => [:stop, :labial],
        "t" => [:stop, :dental],
        "ʧ" => [:stop, :palatal],
        "k" => [:stop, :velar],
        "f" => [:fricative, :labial],
        "θ" => [:fricative, :dental],
        "s" => [:fricative, :alveolar],
        "x" => [:fricative, :velar]
      }

      def self.features
        @@features
      end

      def self.symbols
        @@symbols
      end

      def self.symbols=(hash)
        @@symbols = hash
      end

      attr :symbol_map

      # Given an list of IPA symbols, build the sound inventory.
      def initialize(*symbols)
        @symbol_map = Hash[symbols.map {|sym| [sym, mask(sym)]}]
      end

      # Does the inventory include a sound with the given features?
      def has?(*features)
        !! symbol(*features)
      end

      # Get an int with bits set for the given IPA symbol or features.
      def mask(*args)
        return mask(self[args.shift]) if args.first.kind_of? String
        args.flatten.inject(0) {|m, o| m += @@features[o]}
      end

      # Given a list of features or a feature mask, return an IPA symbol
      def symbol(*args)
        @symbol_map.key args.first.kind_of?(Symbol) ? mask(args) : args.shift
      end

      # Given an IPA symbol, return a list of features
      def[](symbol)
        @@symbols[symbol]
      end
      alias features []

      # Given a set of features, return all symbols that have all.
      def &(*features)
        mask = mask(features.flatten)
        @symbol_map.map {|sym, bits| sym if bits & mask == mask}.compact
      end

      # Given a set of features, return all symbols that have any.
      def |(*features)
        mask = mask(features.flatten)
        @symbol_map.map {|sym, bits| sym if bits & mask != 0}.compact
      end

      # Given a set of features, return all symbols that have none.
      def ^(*features)
        mask = mask(features.flatten)
        @symbol_map.map {|sym, bits| sym if bits & mask == 0}.compact
      end

    end
  end
end
