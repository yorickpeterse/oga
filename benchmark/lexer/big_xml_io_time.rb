require_relative '../benchmark_helper'

Benchmark.bmbm(10) do |bench|
  bench.report '10MB of XML using IO' do
    Oga::XML::Lexer.new(big_xml_file).advance { |tok| }
  end
end
