require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <th> elements' do
    it 'lexes two unclosed <th> elements following each other as separate elements' do
      lex_html('<th>foo<th>bar').should == [
        [:T_ELEM_NAME, 'th', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'th', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <th> followed by a <thead> as separate elements' do
      lex_html('<th>foo<thead>bar').should == [
        [:T_ELEM_NAME, 'th', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <p> followed an unclosed <th> as a child element' do
      lex_html('<th><p>foo').should == [
        [:T_ELEM_NAME, 'th', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
