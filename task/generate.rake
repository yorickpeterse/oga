desc 'Generates auto-generated files'
task :generate => [:lexer, :parser, :compile]
