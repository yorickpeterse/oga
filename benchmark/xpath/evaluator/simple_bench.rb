require_relative '../../benchmark_helper'

document = Oga.parse_xml('<root></root>')
query    = 'root'

Benchmark.ips do |bench|
  bench.report(query.inspect) do
    document.xpath(query)
  end
end
