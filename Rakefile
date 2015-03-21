require 'bundler'
require 'bundler/gem_tasks'
require 'digest/sha2'
require 'rake/clean'

GEMSPEC = Gem::Specification.load('oga.gemspec')

if RUBY_PLATFORM == 'java'
  require 'rake/javaextensiontask'

  Rake::JavaExtensionTask.new('liboga', GEMSPEC) do |task|
    task.ext_dir = 'ext/java'
  end
else
  require 'rake/extensiontask'

  Rake::ExtensionTask.new('liboga', GEMSPEC) do |task|
    task.ext_dir = 'ext/c'
  end
end

CLEAN.include(
  'coverage',
  'yardoc',
  'lib/oga/xml/parser.rb',
  'lib/oga/xpath/lexer.rb',
  'lib/oga/xpath/parser.rb',
  'lib/oga/css/lexer.rb',
  'lib/oga/css/parser.rb',
  'benchmark/fixtures/big.xml',
  'profile/samples/**/*.txt',
  'lib/liboga.*',
  'tmp',
  'ext/c/lexer.c',
  'ext/java/org/liboga/xml/Lexer.java'
)

Dir['./task/*.rake'].each do |task|
  import(task)
end

task :default => :test
