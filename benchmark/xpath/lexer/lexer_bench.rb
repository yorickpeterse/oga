require_relative '../../benchmark_helper'

xpath = '/wikimedia/projects/project[@name="Wikipedia"]/editions/edition/text()'

Benchmark.ips do |bench|
  bench.report 'Wikipedia example' do
    Oga::XPath::Lexer.new(xpath).advance { }
  end
end
