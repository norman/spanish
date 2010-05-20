require File.expand_path("../lib/spanish/version", __FILE__)

Gem::Specification.new do |s|
  s.name         = "spanish"
  s.version      = Spanish::VERSION
  s.authors      = ["Norman Clarke"]
  s.email        = "norman@njclarke.com"
  s.homepage     = "http://github.com/norman/spanish"
  s.summary      = "Spanish phonology, orthography and grammar library for Ruby."
  s.description  = "A Spanish phonology, orthography and grammar library for Ruby."
  s.files        = `git ls-files {test,lib}`.split("\n") + %w(README.md LICENSE)
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
  s.add_dependency "phonology", ">= 0.0.5"
  s.required_ruby_version = ">= 1.9"
end
