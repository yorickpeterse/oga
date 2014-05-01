require_relative '../benchmark_helper'

xml = read_big_xml

Benchmark.bmbm(10) do |bench|
  bench.report '10MB of XML' do
    Oga::XML::Lexer.new(xml).advance { |tok| }
  end
end
