require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <ul> elements' do
    it 'lexes an <ul> element containing unclosed <li> elements with text' do
      expect(lex_html('<ul><li>foo<li>bar</ul>')).to eq([
        [:T_ELEM_NAME, 'ul', 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an <ul> element followed by text containing unclosed <li> elements with text' do
      expect(lex_html('<ul><li>foo<li>bar</ul>outside ul')).to eq([
        [:T_ELEM_NAME, 'ul', 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'outside ul', 1]
      ])
    end

    it 'lexes nested <ul> elements containing unclosed <li> elements' do
      expect(lex_html('<ul><li><ul><li>foo</ul><li>bar</ul>')).to eq([
        [:T_ELEM_NAME, 'ul', 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_ELEM_NAME, 'ul', 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
