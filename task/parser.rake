rule '.rb' => '.y' do |task|
  sh "racc -l -o #{task.name} #{task.source}"
end

rule '.rb' => '.rll' do |task|
  sh "ruby-ll #{task.source} -o #{task.name}"
end

desc 'Generates the parser'
task :parser => [
  'lib/oga/xml/parser.rb',
  'lib/oga/xpath/parser.rb',
  'lib/oga/css/parser.rb'
]
