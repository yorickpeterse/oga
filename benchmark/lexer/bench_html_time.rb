require_relative '../../lib/oga'
require 'benchmark'

html = File.read(File.expand_path('../../fixtures/hrs.html', __FILE__))

Benchmark.bmbm(20) do |bench|
  bench.report 'lex HTML' do
    Oga::XML::Lexer.new(html, :html => true).lex
  end
end
