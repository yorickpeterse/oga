desc 'Runs the tests'
task :test => [:regenerate] do
  sh 'rspec spec'
end
