desc 'Runs the tests'
task :test => [:generate] do
  sh 'rspec spec --order random'
end
