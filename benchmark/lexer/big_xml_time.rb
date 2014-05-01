require_relative '../../lib/oga'
require 'benchmark'

xml = File.read(File.expand_path('../../fixtures/big.xml', __FILE__))

Benchmark.bmbm(10) do |bench|
  bench.report '10MB of XML' do
    Oga::XML::Lexer.new(xml).advance { |tok| }
  end
end
