require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <caption> elements' do
    it 'lexes an unclosed <caption> followed by a <thead> as separate elements' do
      lex_html('<caption>foo<thead>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <tbody> as separate elements' do
      lex_html('<caption>foo<tbody>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <tfoot> as separate elements' do
      lex_html('<caption>foo<tfoot>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <tr> as separate elements' do
      lex_html('<caption>foo<tr>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <caption> as separate elements' do
      lex_html('<caption>foo<caption>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <colgroup> as separate elements' do
      lex_html('<caption>foo<colgroup>bar').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an unclosed <caption> followed by a <col> as separate elements' do
      lex_html('<caption>foo<col>').should == [
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'col', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
