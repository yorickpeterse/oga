require_relative '../benchmark_helper'

xml     = read_big_xml
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
