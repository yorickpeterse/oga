require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <dt> elements' do
    it 'lexes two unclosed <dd> elements following each other as separate elements' do
      lex_html('<dd>foo<dd>bar').should == [
        [:T_ELEM_NAME, 'dd', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'dd', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <dd> followed by a <dt> as separate elements' do
      lex_html('<dd>foo<dt>bar').should == [
        [:T_ELEM_NAME, 'dd', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'dt', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
