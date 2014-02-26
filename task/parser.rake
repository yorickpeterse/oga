=begin
rule '.rb' => '.y' do |task|
  Cliver.assert('racc', '~> 1.4')

  sh "racc -l -o #{task.name} #{task.source}"
end

desc 'Generates the parser'
task :parser => [PARSER_OUTPUT]
=end
