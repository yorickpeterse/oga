require_relative '../../lib/oga'
require 'benchmark'

xml    = File.read(File.expand_path('../../fixtures/big.xml', __FILE__))
parser = Oga::XML::Parser.new(xml)

Benchmark.bmbm(10) do |bench|
  bench.report '11MB of XML' do
    parser.parse
  end
end
