require_relative '../../lib/oga'
require 'benchmark/ips'

string = 'Hello, how are you doing today?'
small  = "<![CDATA[#{string}]]>"
medium = "<![CDATA[#{string * 1_000}]]>"
large  = "<![CDATA[#{string * 10_000}]]>"
lexer  = Oga::XML::Lexer.new

Benchmark.ips do |bench|
  bench.report 'CDATA with a small body' do
    lexer.lex(small)
  end

  bench.report 'CDATA with a medium body' do
    lexer.lex(medium)
  end

  bench.report 'CDATA with a large body' do
    lexer.lex(large)
  end
end
