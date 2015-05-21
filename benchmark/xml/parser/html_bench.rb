require_relative '../../benchmark_helper'

require 'nokogiri'

html = read_html

Benchmark.ips do |bench|
  bench.report 'Oga' do
    Oga.parse_html(html)
  end

  bench.report 'Nokogiri' do
    Nokogiri::HTML(html)
  end

  bench.compare!
end
