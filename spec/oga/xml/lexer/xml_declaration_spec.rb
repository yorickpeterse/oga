require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'XML declaration tags' do
    it 'lexes a start tag' do
      lex('<?xml').should == [[:T_XML_DECL_START, nil, 1]]
    end

    it 'lexes a start and end tag' do
      lex('<?xml?>').should == [
        [:T_XML_DECL_START, nil, 1],
        [:T_XML_DECL_END, nil, 1]
      ]
    end

    it 'lexes a tag with text inside it' do
      lex('<?xml version="1.0" ?>').should == [
        [:T_XML_DECL_START, nil, 1],
        [:T_ATTR, 'version', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, '1.0', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_XML_DECL_END, nil, 1]
      ]
    end
  end
end
