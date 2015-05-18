require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <li> elements' do
    it 'lexes two unclosed <li> elements following each other as separate elements' do
      lex_html('<li>foo<li>bar').should == [
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'li', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
