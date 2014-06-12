require_relative '../../profile_helper'

profile_memory('xml/lexer/big_xml') do
  Oga::XML::Lexer.new(big_xml_file).advance { }
end
