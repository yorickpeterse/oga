require_relative '../../benchmark_helper'

xml = read_big_xml

measure_average do
  Oga::XML::Lexer.new(xml).advance { }
end
