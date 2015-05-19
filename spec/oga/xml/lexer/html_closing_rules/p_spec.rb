require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <p> elements' do
    it 'lexes two unclosed <p> elements following each other as separate elements' do
      lex_html('<p>foo<p>bar').should == [
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <p> followed by a <address> as separate elements' do
      lex_html('<p>foo<address>bar').should == [
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'address', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
