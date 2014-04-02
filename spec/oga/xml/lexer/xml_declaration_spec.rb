require 'spec_helper'

describe Oga::XML::Lexer do
  context 'XML declaration tags' do
    example 'lex a start tag' do
      lex('<?xml').should == [[:T_XML_DECL_START, nil, 1]]
    end

    example 'lex a start and end tag' do
      lex('<?xml?>').should == [
        [:T_XML_DECL_START, nil, 1],
        [:T_XML_DECL_END, nil, 1]
      ]
    end

    example 'lex a tag with text inside it' do
      lex('<?xml version="1.0" ?>').should == [
        [:T_XML_DECL_START, nil, 1],
        [:T_ATTR, 'version', 1],
        [:T_STRING, '1.0', 1],
        [:T_XML_DECL_END, nil, 1]
      ]
    end
  end
end
