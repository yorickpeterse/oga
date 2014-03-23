require_relative '../../lib/oga'
require 'benchmark'

html  = File.read(File.expand_path('../../fixtures/hrs.html', __FILE__))
lexer = Oga::Lexer.new(:html => true)

Benchmark.bmbm(20) do |bench|
  bench.report 'lex HTML' do
    lexer.lex(html)
  end
end
