# encoding: utf-8
require File.expand_path("../../init.rb", __FILE__)

words = File.read(File.expand_path("../spanish.txt", __FILE__)).split("\n")
50.times do
  begin
    word = words[rand(words.length)]
    trans = Spanish.get_sounds(word)
    l = 20
    puts "%#{l}s %#{l}s %#{l}s" % [word, trans.map(&:symbol).join, trans.map(&:orthography).join]
  rescue => e
    puts "Died on #{word}"
    raise e
  end
end
