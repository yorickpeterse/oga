require_relative '../../benchmark_helper'

measure_average do
  Oga::XML::Lexer.new(big_xml_file).advance { }
end
