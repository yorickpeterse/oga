require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <caption> elements' do
    it 'lexes an unclosed <caption> followed by a <thead> as separate elements' do
      expect(lex_html('<caption>foo<thead>bar')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <caption> followed by a <tbody> as separate elements' do
      expect(lex_html('<caption>foo<tbody>bar')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <caption> followed by a <tfoot> as separate elements' do
      expect(lex_html('<caption>foo<tfoot>bar')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <caption> followed by a <tr> as separate elements' do
      expect(lex_html('<caption>foo<tr>bar')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <caption> followed by a <caption> as separate elements' do
      expect(lex_html('<caption>foo<caption>bar')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <caption> followed by a <colgroup> as separate elements' do
      expect(lex_html('<caption>foo<colgroup>bar')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'colgroup', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <caption> followed by a <col> as separate elements' do
      expect(lex_html('<caption>foo<col>')).to eq([
        [:T_ELEM_NAME, 'caption', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'col', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
