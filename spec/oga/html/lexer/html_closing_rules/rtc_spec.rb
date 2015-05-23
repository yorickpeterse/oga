require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <rt> elements' do
    it 'lexes two unclosed <rtc> elements following each other as separate elements' do
      lex_html('<rtc>foo<rtc>bar').should == [
        [:T_ELEM_NAME, 'rtc', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rtc', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <rtc> followed by a <rb> as separate elements' do
      lex_html('<rtc>foo<rb>bar').should == [
        [:T_ELEM_NAME, 'rtc', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'rb', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
