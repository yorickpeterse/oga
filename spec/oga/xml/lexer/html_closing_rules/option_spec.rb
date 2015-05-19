require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <option> elements' do
    it 'lexes two unclosed <option> elements following each other as separate elements' do
      lex_html('<option>foo<option>bar').should == [
        [:T_ELEM_NAME, 'option', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'option', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <option> followed by a <optgroup> as separate elements' do
      lex_html('<option>foo<optgroup>bar').should == [
        [:T_ELEM_NAME, 'option', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'optgroup', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
