require_relative '../profile_helper'

xml   = read_big_xml
lexer = Oga::XML::Lexer.new(xml)

profile_memory('lexer/big_xml')

lexer.advance { |tok| }
