require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <rb> elements' do
    it 'lexes two unclosed <rb> elements following each other as separate elements' do
      expect(lex_html('<rb>foo<rb>bar')).to eq([
        [:T_ELEM_NAME, 'rb', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rb', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <rb> followed by a <rt> as separate elements' do
      expect(lex_html('<rb>foo<rt>bar')).to eq([
        [:T_ELEM_NAME, 'rb', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rt', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
