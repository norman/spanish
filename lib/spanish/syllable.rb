# @TODO
# Problem words: insubstancialidad, descouella
module Spanish
  class Syllable

    attr_accessor :onset, :coda, :nucleus, :stress

    def initialize(sound = nil)
      @onset = []
      @nucleus = []
      @coda = []
      add sound if sound
    end

    def to_a
      [onset, rime].flatten
    end

    def valid?
      !nucleus.empty?
    end

    def rime
      [nucleus, coda]
    end

    def to_s
      string = to_a.map(&:symbol).join
      (stress ? "\u02c8" : "") + string
    end

    def wants?(sound)
      onset_wants?(sound) or nucleus_wants?(sound) or coda_wants?(sound)
    end

    def onset_wants?(sound)
      if !nucleus.empty? || sound.vocalic?
        false
      elsif onset.empty?
        sound.consonantal?
      else
        sound.liquid? || sound.approximant?
      end
    end

    def nucleus_wants?(sound)
      if !coda.empty? || nucleus.length == 2 || !sound.vocalic?
        false
      elsif nucleus.empty?
        true
      elsif nucleus.last != sound
        !nucleus.last.hints.include?(:primary_stress) &&
          !sound.hints.include?(:syllable_boundary) &&
          (nucleus.last.close? || !nucleus.last.close? && sound.close?)
      end
    end

    def coda_wants?(sound)
      if nucleus.empty?
        false
      else
        # Codas don't want a rising dipthong but will accept one at the end of words.
        sound.consonantal? && !(sound.approximant? && sound.palatal?)
      end
    end

    def <<(sound)
      @stress = true if sound.hints.include?(:primary_stress)
      if onset_wants?(sound)
        @onset << sound
      elsif nucleus_wants?(sound)
        @nucleus << sound
      else
        @coda << sound
      end
    end
    alias add <<

    def empty?
      onset.empty? && nucleus.empty? && coda.empty?
    end

    def self.apply_stress(syllables)
      if syllables.detect {|s| s.stress}
      elsif syllables.length == 1
        syllables[0].stress = true
      else
        last = syllables.last.to_a
        penult = syllables[-2].to_a
        if last.last.vocalic? or last.last.nasal? or (last.last.alveolar? && last.last.fricative?)
          syllables[-2].stress = true
        else
          syllables.last.stress = true
        end
      end
      syllables
    end

    def self.syllabify(arg)
      arg = arg.kind_of?(String) ? Spanish.get_sounds(arg) : arg
      apply_stress(Syllables.new(arg).entries)
    end

    class Syllables

      include Enumerable

      attr :index, :sounds, :syllable

      def initialize(sounds)
        @sounds = sounds
      end

      def each(&block)
        begin
          sounds.each_index { |i| @index = i; append or do_yield(&block) }
          do_yield(&block)
        ensure
          @index = 0
          @syllable = nil
        end
      end

      private

      def do_yield(&block)
        yield syllable
        @syllable = Syllable.new(curr)
      end

      def syllable
        @syllable ||= Syllable.new
      end

      def append
        return if !curr
        # Final consonantal has nowhere else to go.
        if !nex && curr.consonantal?
          syllable << curr
        # If there's no room in the syllable, we're forced to start a new one.
        elsif !syllable.wants? curr
          false
        # Spanish has a strong aversion to syllable-initial consonant clusters
        # beginning with "s".
        elsif syllable.wants?(curr) && nex && curr.alveolar? && curr.fricative? && nex.non_vocoid?
          syllable << curr
        # Otherwise, the preference is to be the onset of a new syllable. This
        # is only possible when the syllable we would create has sonority rising
        # towards the nucleus.
        elsif nex && syllable.valid? && (nex.sonority - curr.sonority > 1)
          false
        # Default action is to append to current syllable.
        else
          syllable << curr
        end
      end

      def curr
        @sounds[index]
      end

      def prev
        @sounds[index - 1] unless index == 0
      end

      def nex
        @sounds[index + 1]
      end

    end


  end

end