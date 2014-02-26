require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'
require 'cliver'

GEMSPEC = Gem::Specification.load('oga.gemspec')

LEXER_INPUT  = 'lib/oga/lexer.rl'
LEXER_OUTPUT = 'lib/oga/lexer.rb'

#PARSER_INPUT  = 'lib/oga/parser.y'
#PARSER_OUTPUT = 'lib/oga/parser.rb'

GENERATED_FILES = ['coverage', 'yardoc', LEXER_OUTPUT]

GENERATED_FILES.each do |file|
  CLEAN << file if File.exist?(file)
end

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
