require_relative '../../benchmark_helper'

xml     = read_big_xml
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
