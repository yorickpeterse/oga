require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <rt> elements' do
    it 'lexes two unclosed <rt> elements following each other as separate elements' do
      lex_html('<rt>foo<rt>bar').should == [
        [:T_ELEM_NAME, 'rt', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rt', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <rt> followed by a <rtc> as separate elements' do
      lex_html('<rt>foo<rtc>bar').should == [
        [:T_ELEM_NAME, 'rt', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rtc', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
