# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'suspenders/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Suspenders::RUBY_VERSION}"
  s.authors = ['thoughtbot', 'weLaika']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
weLaika's fork of the famous thoughbot suspenders gem.
  HERE

  s.email = 'info@welaika.com'
  s.executables = ['welaika-suspenders']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/welaika/welaika-suspenders'
  s.license = 'MIT'
  s.name = 'welaika-suspenders'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using thoughtbot's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Suspenders::VERSION

  s.add_dependency 'bundler', '>= 1.8.4'
  s.add_dependency 'rails', Suspenders::RAILS_VERSION

  s.add_development_dependency 'rspec', '~> 3.6'
end
