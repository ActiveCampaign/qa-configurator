# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config/version'

Gem::Specification.new do |s|
  s.name        = 'configurator'
  s.version     = Configurator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'

  s.authors     = ['Igor Balos']
  s.email       = ['ibalosh@gmail.com', 'igor@wildbit.com']

  s.summary     = 'Config tool.'
  s.description = 'Config tool.'

  s.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")
  s.homepage    = 'https://github.com/wildbit/configurator'
  s.require_paths = ['lib']
  s.required_rubygems_version = '>= 1.9.3'
end
