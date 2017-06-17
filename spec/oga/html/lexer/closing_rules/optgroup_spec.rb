require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML optgroup elements' do
    describe 'with unclosed <optgroup> tags' do
      it 'lexes an <option> tag followed by a <optgroup> tag' do
        expect(lex_html('<optgroup><option>foo<optgroup><option>bar')).to eq([
          [:T_ELEM_NAME, 'optgroup', 1],
          [:T_ELEM_NAME, 'option', 1],
          [:T_TEXT, 'foo', 1],
          [:T_ELEM_END, nil, 1],
          [:T_ELEM_END, nil, 1],
          [:T_ELEM_NAME, 'optgroup', 1],
          [:T_ELEM_NAME, 'option', 1],
          [:T_TEXT, 'bar', 1],
          [:T_ELEM_END, nil, 1],
          [:T_ELEM_END, nil, 1]
        ])
      end
    end
  end
end
