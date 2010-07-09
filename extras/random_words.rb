# encoding: utf-8
require "rubygems"
require "bundler"
Bundler.setup
require File.expand_path("../../init.rb", __FILE__)

words = File.read(File.expand_path("../spanish.txt", __FILE__)).split("\n")
rules = ARGV.map(&:to_sym)
50.times do
  begin
    word = words[rand(words.length)]
    trans = Spanish.get_sounds(word, :seseo, :zheismo, :aspiration)
    l = 20
    puts "%#{l}s %#{l}s" % [
        word,
        Spanish.get_syllables_ipa(word, *rules)
    ]
  rescue => e
    puts "Died on #{word}"
    raise e
  end
end
