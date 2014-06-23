require_relative '../../benchmark_helper'

xml = read_big_xml

Benchmark.ips do |bench|
  bench.report '10MB as a String' do
    Oga::XML::PullParser.new(xml).parse { }
  end

  bench.report '10MB as an IO' do
    Oga::XML::PullParser.new(big_xml_file).parse { }
  end
end
