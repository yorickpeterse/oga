desc 'Generates auto-generated files'
task :generate => [:lexer, :parser]

desc 'Regenerates auto-generated files'
task :regenerate => [:clean, :generate]
