require_relative '../../lib/oga'
require 'benchmark/ips'

html = File.read(File.expand_path('../../fixtures/hrs.html', __FILE__))

Benchmark.ips do |bench|
  bench.report 'parse HTML' do
    Oga::HTML::Parser.new(html).parse
  end
end
