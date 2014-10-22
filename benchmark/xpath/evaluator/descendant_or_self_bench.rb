require_relative '../../benchmark_helper'

document = Oga.parse_html(read_html)

Benchmark.ips do |bench|
  bench.report 'short form' do
    document.xpath('//meta')
  end

  bench.report 'long form' do
    document.xpath('descendant-or-self::meta')
  end
end
