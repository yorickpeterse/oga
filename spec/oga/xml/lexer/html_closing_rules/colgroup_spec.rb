require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML colgroup elements' do
    it 'lexes an unclosed <colgroup> followed by another <colgroup>' do
      lex_html('<colgroup>foo<colgroup>bar').should == [
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
