require_relative '../../benchmark_helper'

css = 'foo bar bar.some_class element#with_id[title="Foo"]'

Benchmark.ips do |bench|
  bench.report 'CSS' do
    Oga::CSS::Parser.new(css).parse
  end
end
