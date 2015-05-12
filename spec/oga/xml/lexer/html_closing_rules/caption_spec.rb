require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML caption elements' do
    it 'lexes an unclosed <caption> followed by another <caption>' do
      lex_html('<caption>foo<caption>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <colgroup>' do
      lex_html('<caption>foo<colgroup>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
