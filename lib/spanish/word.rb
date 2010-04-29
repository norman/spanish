module Spanish

  class Word < String

    include Syllabification

    # An array of letters in the word
    def self.letters(string)
      string.scan LETTERS
    end

    # An array of letters in the word
    def letters
      self.class.letters(self)
    end

  end

end
