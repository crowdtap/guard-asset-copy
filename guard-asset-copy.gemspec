# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-asset-copy'
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael D'Auria"]
  s.email       = ['michael.dauria@gmail.com']
  s.homepage    = ''
  s.summary     = %q{Guard that will merely copy files from the assets dir into public}
  s.description = %q{Guard that will merely copy files from the assets dir into public}

  s.rubyforge_project = 'guard-asset-copy'

  s.add_dependency('guard', '>= 0.4')

  s.add_development_dependency('rspec')

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE Gemfile]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']
end
