require "rake/testtask"
require "rake/gempackagetask"
require "rake/clean"

CLEAN << "pkg" << "doc" << "coverage" << ".yardoc"

task :default => :test

Rake::TestTask.new(:test) { |t| t.pattern = "test/**/*_test.rb" }
Rake::GemPackageTask.new(eval(File.read("spanish.gemspec"))) { |pkg| }

begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
  end
rescue LoadError
end
