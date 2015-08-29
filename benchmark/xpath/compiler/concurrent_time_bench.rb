require_relative '../../benchmark_helper'
require 'thread'

puts 'Preparing...'

xml       = read_big_kaf
xpath     = 'KAF/terms/term'
xpath_ast = Oga::XPath::Parser.new(xpath).parse
output    = Queue.new

stop    = false
threads = []

thread_count = ENV['THREADS'] ? ENV['THREADS'].to_i : 5
sample_size  = ENV['SAMPLES'] ? ENV['SAMPLES'].to_i : 10

trap 'INT' do
  stop = true
end

# Parse these outside of the profiler
documents = thread_count.times.map { Oga.parse_xml(xml) }

puts 'Starting threads...'

require 'profile' if ENV['PROFILE']

thread_count.times.each do
  threads << Thread.new do
    oga_doc   = documents.pop
    compiler  = Oga::XPath::Compiler.new
    block     = compiler.compile(xpath_ast)

    sample_size.times do
      break if stop

      output << Benchmark.measure { block.call(oga_doc) }
    end
  end
end

threads.each(&:join)

samples = []

until output.empty?
  samples << output.pop.real
end

average = samples.inject(:+) / samples.length

puts "Samples: #{samples.length}"
puts "Average: #{average.round(4)} seconds"
