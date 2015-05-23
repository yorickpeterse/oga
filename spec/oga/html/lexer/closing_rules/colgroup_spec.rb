require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <colgroup> elements' do
    it 'lexes two unclosed <colgroup> elements as separate elements' do
      lex_html('<colgroup>foo<colgroup>bar').should == [
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <col> element following a <colgroup> as a child element' do
      lex_html('<colgroup><col>').should == [
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_ELEM_NAME, 'col', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <template> element following a <colgroup> as a child element' do
      lex_html('<colgroup><template>').should == [
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_ELEM_NAME, 'template', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
