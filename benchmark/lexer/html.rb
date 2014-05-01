require_relative '../../lib/oga'
require 'benchmark/ips'

html = File.read(File.expand_path('../../fixtures/gist.html', __FILE__))

Benchmark.ips do |bench|
  bench.report 'lex HTML' do
    Oga::XML::Lexer.new(html, :html => true).lex
  end
end
