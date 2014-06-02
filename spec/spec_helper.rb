require 'rspec'
require 'stringio'

if ENV['COVERAGE']
  require_relative 'support/simplecov'
end

require_relative '../lib/oga'
require_relative 'support/parsing'

RSpec.configure do |config|
  config.color = true
  config.include Oga::ParsingHelpers

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
