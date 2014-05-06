require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'
require 'cliver'

GEMSPEC = Gem::Specification.load('oga.gemspec')

if RUBY_PLATFORM == 'java'
  require 'rake/javaextensiontask'

  Rake::JavaExtensionTask.new('liboga', GEMSPEC)
else
  require 'rake/extensiontask'

  Rake::ExtensionTask.new('liboga', GEMSPEC)
end

PARSER_OUTPUT = 'lib/oga/xml/parser.rb'

CLEAN.include(
  'coverage',
  'yardoc',
  PARSER_OUTPUT,
  'benchmark/fixtures/big.xml',
  'profile/samples/**/*.txt',
  'lib/liboga.*',
  'tmp',
  'ext/c/liboga/lexer.c'
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

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
