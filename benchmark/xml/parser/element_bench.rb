require_relative '../../benchmark_helper'

simple     = '<p>Hello world</p>'
attributes = '<p class="foo">Hello world</p>'
nested     = '<p>Hello<strong>world</strong></p>'

Benchmark.ips do |bench|
  bench.report 'text only' do
    Oga::XML::Parser.new(simple).parse
  end

  bench.report 'text + attributes' do
    Oga::XML::Parser.new(attributes).parse
  end

  bench.report 'text + children' do
    Oga::XML::Parser.new(nested).parse
  end
end
