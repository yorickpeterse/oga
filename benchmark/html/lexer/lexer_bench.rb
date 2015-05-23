require_relative '../../benchmark_helper'

html = read_html

Benchmark.ips do |bench|
  bench.report 'lex HTML' do
    Oga::XML::Lexer.new(html, :html => true).advance { }
  end
end
