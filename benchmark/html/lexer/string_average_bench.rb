require_relative '../../benchmark_helper'

xml = read_big_xml

measure_average do
  Oga::XML::Lexer.new(xml, :html => true).advance { }
end
