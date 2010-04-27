module Spanish

  # A verb.
  class Verb

    attr_reader :root
    attr_reader :type

    def initialize(verb)
      @root, @type = verb.downcase.split(/(ar|er|ir)\z/)
    end

  end

end
