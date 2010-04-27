module Spanish

  class Word < String

    include Syllabification

    # An array of letters in the word
    def letters
      scan LETTERS
    end

  end

end
