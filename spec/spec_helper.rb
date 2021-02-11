# frozen_string_literal: true

require 'rspec'
require 'configurator'
require 'pry'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

RSpec.configure do |c|
  c.formatter = :documentation
  c.color = true
end