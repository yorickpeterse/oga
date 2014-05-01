require_relative '../benchmark_helper'

html = read_html

Benchmark.ips do |bench|
  bench.report 'parse HTML' do
    Oga::HTML::Parser.new(html).parse
  end
end
