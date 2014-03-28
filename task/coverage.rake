desc 'Generates code coverage'
task :coverage do
  ENV['COVERAGE'] = '1'

  Rake::Task['test'].invoke
end
