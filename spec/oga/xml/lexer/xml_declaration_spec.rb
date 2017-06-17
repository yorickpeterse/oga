require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'XML declaration tags' do
    it 'lexes a start tag' do
      expect(lex('<?xml')).to eq([[:T_XML_DECL_START, nil, 1]])
    end

    it 'lexes a start and end tag' do
      expect(lex('<?xml?>')).to eq([
        [:T_XML_DECL_START, nil, 1],
        [:T_XML_DECL_END, nil, 1]
      ])
    end

    it 'lexes a tag with text inside it' do
      expect(lex('<?xml version="1.0" ?>')).to eq([
        [:T_XML_DECL_START, nil, 1],
        [:T_ATTR, 'version', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, '1.0', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_XML_DECL_END, nil, 1]
      ])
    end

    it 'lexes a declaration with a newline after the open tag' do
      expect(lex("<?xml\n?>")).to eq([
        [:T_XML_DECL_START, nil, 1],
        [:T_XML_DECL_END, nil, 2]
      ])
    end

    it 'lexes a declaration with a newline followed by an attribute' do
      expect(lex("<?xml\na='b'?>")).to eq([
        [:T_XML_DECL_START, nil, 1],
        [:T_ATTR, 'a', 2],
        [:T_STRING_SQUOTE, nil, 2],
        [:T_STRING_BODY, 'b', 2],
        [:T_STRING_SQUOTE, nil, 2],
        [:T_XML_DECL_END, nil, 2]
      ])
    end

    describe 'using an IO as input' do
      it 'lexes a declaration with a newline after the open tag' do
        expect(lex_stringio("<?xml\n?>")).to eq([
          [:T_XML_DECL_START, nil, 1],
          [:T_XML_DECL_END, nil, 2]
        ])
      end
    end
  end
end
