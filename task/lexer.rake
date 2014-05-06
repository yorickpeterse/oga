rule '.rb' => '.rl' do |task|
  Cliver.assert('ragel', '~> 6.7')

  sh "ragel -F1 -R #{task.source} -o #{task.name}"

  puts "Applying patch http://git.io/ow6e1A to #{task.name}"

  # Patches the lexer based on http://git.io/ow6e1A.
  input  = File.read(task.source)
  output = File.read(task.name)
  getkey = input.match(/getkey\s+(.+);/)[1]

  output = output.gsub(getkey, '_wide')
  output = output.gsub('_trans = if', "_wide = #{getkey}\n  _trans = if")

  File.open(task.name, 'w') do |handle|
    handle.write(output)
  end
end

rule '.c' => '.rl' do |task|
  Cliver.assert('ragel', '~> 6.7')

  sh "ragel -C -G2 #{task.source} -o #{task.name}"
end

desc 'Generates the lexers'
task :lexer => ['ext/liboga/lexer.c']
