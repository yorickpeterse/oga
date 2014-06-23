require_relative '../../benchmark_helper'

xml = read_big_xml

Benchmark.ips do |bench|
  bench.report '10MB as a String' do
    Oga::XML::Lexer.new(xml).advance { }
  end

  bench.report '10MB as an IO' do
    Oga::XML::Lexer.new(big_xml_file).advance { }
  end
end
