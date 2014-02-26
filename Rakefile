require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'
require 'cliver'

GEMSPEC = Gem::Specification.load('oga.gemspec')

LEXER_INPUT  = 'lib/oga/lexer.rl'
LEXER_OUTPUT = 'lib/oga/lexer.rb'

HTML_PARSER = 'lib/oga/parser/html.rb'

GENERATED_FILES = ['coverage', 'yardoc', LEXER_OUTPUT, HTML_PARSER]

GENERATED_FILES.each do |file|
  CLEAN << file if File.exist?(file)
end

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
