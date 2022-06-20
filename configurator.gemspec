# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'config/version'

Gem::Specification.new do |s|
  s.name        = 'wbconfigurator'
  s.version     = Configurator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'

  s.authors     = ['Igor Balos']
  s.email       = ['ibalosh@gmail.com', 'ibalos@activecampaign.com']

  s.summary     = 'Config tool.'
  s.description = 'Configuration tool for simple management with yaml files.'

  s.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files  = `git ls-files -- {spec}/*`.split("\n")
  s.homepage    = 'https://github.com/ActiveCampaign/qa-configurator'
  s.require_paths = ['lib']
  s.required_rubygems_version = '>= 1.9.3'
  s.add_dependency 'secure_yaml', '~> 2.0'
end
