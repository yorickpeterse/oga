require_relative '../../lib/oga'
require 'benchmark/ips'

simple     = '<p>Hello world</p>'
attributes = '<p class="foo">Hello world</p>'
nested     = '<p>Hello<strong>world</strong></p>'
lexer      = Oga::Lexer.new

Benchmark.ips do |bench|
  bench.report 'text only' do
    lexer.lex(simple)
  end

  bench.report 'text + attributes' do
    lexer.lex(attributes)
  end

  bench.report 'text + children' do
    lexer.lex(nested)
  end
end
