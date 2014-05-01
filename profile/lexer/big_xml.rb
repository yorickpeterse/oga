require_relative '../profile_helper'

xml = read_big_xml

profile_memory('lexer/big_xml') do
  Oga::XML::Lexer.new(xml).advance { }
end
