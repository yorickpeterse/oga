rule '.rb' => '.y' do |task|
  sh "racc -l -o #{task.name} #{task.source}"
end

desc 'Generates the parser'
task :parser => [PARSER_OUTPUT]
