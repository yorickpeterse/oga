require 'rspec'

if ENV['COVERAGE']
  require_relative 'support/simplecov'
end

require_relative '../lib/oga'
require_relative 'support/parsing'

RSpec.configure do |config|
  config.color = true
  config.include Oga::ParsingHelpers
end
