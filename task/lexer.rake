rule '.rb' => '.rl' do |task|
  Cliver.assert('ragel', '~> 6.7')

  sh "ragel -F1 -R #{task.source} -o #{task.name}"
end

desc 'Generates the lexer'
task :lexer => [LEXER_OUTPUT]
