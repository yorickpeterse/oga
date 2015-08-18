require 'bundler/setup'
require 'stringio'
require 'benchmark'
require 'benchmark/ips'
require 'oga'

# @return [File]
def big_xml_file
  File.open(File.expand_path('../fixtures/big.xml', __FILE__), 'r')
end

# @return [File]
def big_kaf_file
  File.open(File.expand_path('../fixtures/kaf.xml', __FILE__), 'r')
end

# @return [String]
def read_big_xml
  big_xml_file.read
end

# @return [String]
def read_big_kaf
  big_kaf_file.read
end

# @return [String]
def read_html
  return File.read(File.expand_path('../fixtures/with_entities.html', __FILE__))
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
