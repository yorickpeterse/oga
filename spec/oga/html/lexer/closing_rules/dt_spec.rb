require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <dt> elements' do
    it 'lexes two unclosed <dt> elements following each other as separate elements' do
      expect(lex_html('<dt>foo<dt>bar')).to eq([
        [:T_ELEM_NAME, 'dt', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'dt', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <dt> followed by a <dd> as separate elements' do
      expect(lex_html('<dt>foo<dd>bar')).to eq([
        [:T_ELEM_NAME, 'dt', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'dd', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
