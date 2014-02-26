require 'simplecov'

SimpleCov.configure do
  root         File.expand_path('../../../', __FILE__)
  command_name 'rspec'
  project_name 'oga'

  add_filter 'spec'
  add_filter 'lib/oga/version'
end

SimpleCov.start
