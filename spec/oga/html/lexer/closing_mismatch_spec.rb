require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'closing HTML elements with mismatched closing tags' do
    it 'lexes a <p> element closed using a </div> element' do
      expect(lex_html('<p>foo</div>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <param> element' do
      expect(lex_html('<object><param></param><param></param></object>')).to eq([
        [:T_ELEM_NAME, 'object', 1],
        [:T_ELEM_NAME, 'param', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'param', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
