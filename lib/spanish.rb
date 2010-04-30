# encoding: utf-8
require File.expand_path("../linguistics/phonology", __FILE__)
require File.expand_path("../spanish/syllabification", __FILE__)
require File.expand_path("../spanish/word", __FILE__)
require File.expand_path("../spanish/verb", __FILE__)
require File.expand_path("../spanish/features", __FILE__)
require File.expand_path("../spanish/phonology", __FILE__)

# This library provides some linguistic and orthographic tools for Spanish
# words.
module Spanish

  # Regexp for the letters/letter+diacritics used in Spanish
  LETTERS = /ch|ll|á|é|í|ó|ú|ü|ñ|[\w]/

end
