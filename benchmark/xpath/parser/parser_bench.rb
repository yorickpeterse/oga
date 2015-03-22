require_relative '../../benchmark_helper'

xpath = '/wikimedia/projects/project[@name="Wikipedia"]/editions/edition/text()'

Benchmark.ips do |bench|
  bench.report 'without cache' do
    Oga::XPath::Parser.new(xpath).parse
  end

  bench.report 'with cache' do
    Oga::XPath::Parser.parse_with_cache(xpath)
  end

  bench.compare!
end
