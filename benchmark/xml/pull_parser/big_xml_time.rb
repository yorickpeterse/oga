require_relative '../../benchmark_helper'

xml    = read_big_xml
parser = Oga::XML::PullParser.new(xml)

Benchmark.bmbm(10) do |bench|
  bench.report '10MB of XML' do
    parser.parse { |node| }
  end
end
