module SpanishVerbs

  module Features

    extend self

    attr_reader :person, :mood, :tense

    # if no bits set, then 1st
    @person = {
      :second   => 1 << 0,
      :third    => 1 << 1,
      :plural   => 1 << 2,
      :familiar => 1 << 3
    }

    # if no bits set, then indicative
    @mood = {
      :subjunctive => 1 << 0,
      :progressive => 1 << 1,
      :imperative  => 1 << 2,
      :negative    => 1 << 3 # can only be combined with imperative
    }

    # if no bits set, then present
    @tense = {
      :preterite   => 1 << 0,
      :imperfect   => 1 << 1,
      :future      => 1 << 2,
      :conditional => 1 << 3
    }

  end

end
