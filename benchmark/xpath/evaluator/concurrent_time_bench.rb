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
    evaluator = Oga::XPath::Evaluator.new(oga_doc)

    10.times do
      break if stop

      output << Benchmark.measure { evaluator.evaluate_ast(xpath_ast) }
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
