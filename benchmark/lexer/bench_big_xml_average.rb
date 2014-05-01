require_relative '../../lib/oga'
require 'benchmark'

xml     = File.read(File.expand_path('../../fixtures/big.xml', __FILE__))
amount  = 10
timings = []

amount.times do |i|
  timing = Benchmark.measure do
    Oga::XML::Lexer.new(xml).advance { }
  end

  puts "Iteration #{i + 1}: #{timing.real.round(3)}"

  timings << timing.real
end

average = timings.inject(:+) / amount

puts
puts "Iterations: #{amount}"
puts "Average:    #{average.round(3)} sec"
