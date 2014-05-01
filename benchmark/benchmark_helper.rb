require 'benchmark'
require 'benchmark/ips'

require_relative '../lib/oga'

##
# Reads a big XML file and returns it as a String.
#
# @return [String]
#
def read_big_xml
  return File.read(File.expand_path('../fixtures/big.xml', __FILE__))
end

##
# Reads a normal sized HTML fixture.
#
# @return [String]
#
def read_html
  return File.read(File.expand_path('../fixtures/gist.html', __FILE__))
end

##
# Benchmarks the average runtime of the given block.
#
# @param [Fixnum] amount The amount of times to call the block.
# @param [Fixnum] precision
#
def measure_average(amount = 10, precision = 3)
  timings = []

  amount.times do |iter|
    timing = Benchmark.measure { yield }.real

    timings << timing.real

    puts "Iteration: #{iter + 1}: #{timing.real.round(precision)}"
  end

  average = timings.inject(:+) / timings.length

  puts
  puts "Iterations: #{amount}"
  puts "Average:    #{average.round(precision)} sec"
end
