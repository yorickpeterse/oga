require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <rp> elements' do
    it 'lexes two unclosed <rp> elements following each other as separate elements' do
      lex_html('<rp>foo<rp>bar').should == [
        [:T_ELEM_NAME, 'rp', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rp', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <rp> followed by a <rb> as separate elements' do
      lex_html('<rp>foo<rb>bar').should == [
        [:T_ELEM_NAME, 'rp', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rb', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
