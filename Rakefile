require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'
require 'cliver'

GEMSPEC = Gem::Specification.load('oga.gemspec')

LEXER_OUTPUT  = 'lib/oga/xml/lexer.rb'
PARSER_OUTPUT = 'lib/oga/xml/parser.rb'

CLEAN.include(
  'coverage',
  'yardoc',
  LEXER_OUTPUT,
  PARSER_OUTPUT,
  'benchmark/fixtures/big.xml'
)

FILE_LIST = FileList.new(
  'checkum/**/*.*',
  'doc/**/*.*',
  'lib/**/*.*',
  'LICENSE',
  'MANIFEST',
  '*.gemspec',
  'README.md'
)

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
