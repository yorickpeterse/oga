require_relative '../../lib/oga'
require 'benchmark/ips'

string = 'Hello, how are you doing today?'
small  = "<![CDATA[#{string}]]>"
medium = "<![CDATA[#{string * 1_000}]]>"
large  = "<![CDATA[#{string * 10_000}]]>"

Benchmark.ips do |bench|
  bench.report 'CDATA with a small body' do
    Oga::XML::Lexer.new(small).lex
  end

  bench.report 'CDATA with a medium body' do
    Oga::XML::Lexer.new(medium).lex
  end

  bench.report 'CDATA with a large body' do
    Oga::XML::Lexer.new(large).lex
  end
end
