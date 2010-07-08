# encoding: utf-8
require "rubygems"
require "bundler"
Bundler.setup
require File.expand_path("../../init.rb", __FILE__)

until ARGV.empty?
  word = ARGV.shift
  trans = Spanish.get_sounds(word)
  puts Spanish::Syllable.syllabify(word).map {|s| s.to_s }.join(" ")
end
