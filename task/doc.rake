desc 'Generates YARD documentation'
task :doc => :generate do
  sh 'yard'
end
