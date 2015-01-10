# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_latcheable/version"

Gem::Specification.new do |s|
  s.name     = 'devise_latcheable'
  s.version  = DeviseLatcheable::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary  = 'Devise extension that checks Latch status to log users in the app'
  s.email = 'crresse@gmail.com'
  # s.homepage = ''
  s.description = s.summary
  s.authors = ['Carlos Rodriguez']
  s.license = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('devise', '>= 3.0')

  # s.add_development_dependency('rake', '>= 0.9')
  # s.add_development_dependency('rdoc', '>= 3')
  s.add_development_dependency('rails', '>= 4.0')
  # s.add_development_dependency('sqlite3')
  # s.add_development_dependency('rspec-rails')
end