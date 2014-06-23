require 'simplecov'

SimpleCov.configure do
  root         File.expand_path('../../../', __FILE__)
  command_name 'rspec'
  project_name 'oga'

  add_filter 'spec'
  add_filter 'lib/oga/version'

  add_group 'XML', 'lib/oga/xml'
  add_group 'HTML', 'lib/oga/html'
  add_group 'XPath', 'lib/oga/xpath'
end

SimpleCov.start
