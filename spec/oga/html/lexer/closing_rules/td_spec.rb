require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <td> elements' do
    it 'lexes two unclosed <td> elements following each other as separate elements' do
      expect(lex_html('<td>foo<td>bar')).to eq([
        [:T_ELEM_NAME, 'td', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'td', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <td> followed by a <thead> as separate elements' do
      expect(lex_html('<td>foo<thead>bar')).to eq([
        [:T_ELEM_NAME, 'td', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <p> followed an unclosed <td> as a child element' do
      expect(lex_html('<td><p>foo')).to eq([
        [:T_ELEM_NAME, 'td', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
