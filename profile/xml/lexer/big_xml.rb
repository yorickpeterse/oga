require_relative '../../profile_helper'

xml = read_big_xml

profile_memory('xml/lexer/big_xml') do
  Oga::XML::Lexer.new(xml).advance { }
end
