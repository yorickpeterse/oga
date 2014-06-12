require_relative '../../benchmark_helper'

html = read_html

Benchmark.bmbm(20) do |bench|
  bench.report 'lex HTML' do
    Oga::XML::Lexer.new(html, :html => true).lex
  end
end
