require_relative '../../benchmark_helper'

doc = Oga.parse_xml(big_xml_file)

Benchmark.ips do |bench|
  bench.report 'each_node' do
    doc.each_node { }
  end
end
