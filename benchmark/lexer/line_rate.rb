require_relative '../../lib/oga'
require 'benchmark'

fixture = File.expand_path('../../fixtures/big.xml', __FILE__)

unless File.file?(fixture)
  system('rake fixtures')
  puts
end

xml     = File.read(fixture)
lines   = xml.lines.count
lexer   = Oga::XML::Lexer.new(xml)
timings = Benchmark.bm(20) do |bench|
  bench.report("#{lines} lines") do
    lexer.advance { |_| }
    lexer.reset
  end
end

time = timings[0].real
rate = lines / time

puts
puts "Lines/second: #{rate.round(3)}"
