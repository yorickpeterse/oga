require_relative '../../benchmark_helper'

content  = ''
max_size = 5 * 1024 * 1024

while content.bytesize <= max_size
  content << "<br>"
end

html      = "<body>#{content}</body>"
html_caps = "<body>#{content.upcase}</body>"

Benchmark.ips do |bench|
  bench.report 'void elements' do
    Oga::XML::Lexer.new(html, :html => true).advance { }
  end

  bench.report 'void elements caps' do
    Oga::XML::Lexer.new(html_caps, :html => true).advance { }
  end

  bench.compare!
end
