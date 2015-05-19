require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <tr> elements' do
    it 'lexes two unclosed <tr> elements following each other as separate elements' do
      lex_html('<tr>foo<tr>bar').should == [
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <td> followed an unclosed <tr> as a child element' do
      lex_html('<tr><td>foo').should == [
        [:T_ELEM_NAME, 'tr', 1],
        [:T_ELEM_NAME, 'td', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <th> followed an unclosed <tr> as a child element' do
      lex_html('<tr><th>foo').should == [
        [:T_ELEM_NAME, 'tr', 1],
        [:T_ELEM_NAME, 'th', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
