require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'IO as input' do
    it 'lexes a paragraph element with attributes' do
      io = StringIO.new("<p class='foo'>\nHello</p>")

      expect(lex(io)).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_TEXT, "\n", 1],
        [:T_TEXT, 'Hello', 2],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an attribute value starting with a newline' do
      io    = StringIO.new("<foo bar='\n10'></foo>")
      lexer = described_class.new(io)

      expect(lexer.lex).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ATTR, 'bar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, "\n", 1],
        [:T_STRING_BODY, "10", 2],
        [:T_STRING_SQUOTE, nil, 2],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an attribute value split in two by a newline' do
      io    = StringIO.new("<foo bar='foo\nbar'></foo>")
      lexer = described_class.new(io)

      expect(lexer.lex).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ATTR, 'bar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, "foo\n", 1],
        [:T_STRING_BODY, 'bar', 2],
        [:T_STRING_SQUOTE, nil, 2],
        [:T_ELEM_END, nil, 2]
      ])
    end
  end
end
