require "rake/testtask"
task :default => :test
Rake::TestTask.new(:test) { |t| t.pattern = "test/**/*_test.rb" }


begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = false
  end
rescue LoadError
end
