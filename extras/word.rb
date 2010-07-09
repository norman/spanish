# encoding: utf-8
require "rubygems"
require "bundler"
Bundler.setup
require File.expand_path("../../init.rb", __FILE__)
puts Spanish.get_syllables_ipa(ARGV.shift, *ARGV.map(&:to_sym))