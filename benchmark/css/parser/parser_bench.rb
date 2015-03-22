require_relative '../../benchmark_helper'

css = 'foo bar bar.some_class element#with_id[title="Foo"]'

Benchmark.ips do |bench|
  bench.report 'without cache' do
    Oga::CSS::Parser.new(css).parse
  end

  bench.report 'with cache' do
    Oga::CSS::Parser.parse_with_cache(css)
  end

  bench.compare!
end
