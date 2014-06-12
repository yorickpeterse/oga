require_relative '../../benchmark_helper'

xpath = '/wikimedia/projects/project[@name="Wikipedia"]/editions/edition/text()'

Benchmark.ips do |bench|
  bench.report 'simple XPath' do
    Oga::XPath::Lexer.new(xpath).lex
  end
end
