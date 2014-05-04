require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'
require 'rake/extensiontask'
require 'cliver'

GEMSPEC = Gem::Specification.load('oga.gemspec')

PARSER_OUTPUT = 'lib/oga/xml/parser.rb'

CLEAN.include(
  'coverage',
  'yardoc',
  PARSER_OUTPUT,
  'benchmark/fixtures/big.xml',
  'profile/samples/**/*.txt',
  'lib/liboga.*',
  'tmp',
  'ext/liboga/lexer.c'
)

FILE_LIST = FileList.new(
  'checkum/**/*.*',
  'doc/**/*.*',
  'lib/**/*.rb',
  'LICENSE',
  'MANIFEST',
  '*.gemspec',
  'README.md',
  '.yardopts',
  'ext/**/*.*'
)

Rake::ExtensionTask.new('liboga', GEMSPEC)

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
