rule '.rb' => '.rl' do |task|
  sh "ragel -F1 -R #{task.source} -o #{task.name}"
end

rule '.c' => ['.rl', 'ext/ragel/base_lexer.rl'] do |task|
  sh "ragel -I ext/ragel -C -G2 #{task.source} -o #{task.name}"
end

rule '.java' => ['.rl', 'ext/ragel/base_lexer.rl'] do |task|
  sh "ragel -I ext/ragel -J #{task.source} -o #{task.name}"
end

desc 'Generates the lexers'
multitask :lexer => [
  'ext/c/lexer.c',
  'ext/java/org/liboga/xml/Lexer.java',
  'lib/oga/xpath/lexer.rb',
  'lib/oga/css/lexer.rb'
]
