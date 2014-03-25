require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'
require 'cliver'

GEMSPEC = Gem::Specification.load('oga.gemspec')

LEXER_OUTPUT  = 'lib/oga/xml/lexer.rb'
PARSER_OUTPUT = 'lib/oga/xml/parser.rb'

GENERATED_FILES = ['coverage', 'yardoc', LEXER_OUTPUT, PARSER_OUTPUT]

GENERATED_FILES.each do |file|
  CLEAN << file if File.exist?(file)
end

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
