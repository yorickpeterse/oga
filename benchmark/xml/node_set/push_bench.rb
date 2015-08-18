require_relative '../../benchmark_helper'

# Assigning to an Array first saves the need (and overhead) of calling #push for
# every iteration.
initial = 20_000.times.map do |number|
  Oga::XML::Element.new(:name => number.to_s)
end

initial = Oga::XML::NodeSet.new(initial)

Benchmark.ips do |bench|
  bench.report 'XML::NodeSet#push' do
    new_set = Oga::XML::NodeSet.new

    initial.each { |node| new_set << node }
  end
end
