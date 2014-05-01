require_relative '../benchmark_helper'

simple     = '<p>Hello world</p>'
attributes = '<p class="foo">Hello world</p>'
nested     = '<p>Hello<strong>world</strong></p>'

Benchmark.ips do |bench|
  bench.report 'text only' do
    Oga::XML::Lexer.new(simple).lex
  end

  bench.report 'text + attributes' do
    Oga::XML::Lexer.new(attributes).lex
  end

  bench.report 'text + children' do
    Oga::XML::Lexer.new(nested).lex
  end
end
