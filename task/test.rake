desc 'Runs the tests'
task :test => [:generate, :compile] do
  sh 'rspec spec'
end
