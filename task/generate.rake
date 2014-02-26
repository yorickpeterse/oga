desc 'Generates auto-generated files'
task :generate => [:lexer]

desc 'Regenerates auto-generated files'
task :regenerate => [:clean, :generate]
