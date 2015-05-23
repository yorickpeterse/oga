require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML tables' do
    describe 'with unclosed <tr> tags' do
      it 'lexes a <tr> tag followed by a <tbody> tag' do
        lex_html('<tr>foo<tbody></tbody>').should == [
          [:T_ELEM_NAME, 'tr', 1],
          [:T_TEXT, 'foo', 1],
          [:T_ELEM_END, nil, 1],
          [:T_ELEM_NAME, 'tbody', 1],
          [:T_ELEM_END, nil, 1]
        ]
      end

      it 'lexes an unclosed <th> tag followed by a <tbody> tag' do
        lex_html('<tr><th>foo<tbody>bar</tbody>').should == [
          [:T_ELEM_NAME, 'tr', 1],
          [:T_ELEM_NAME, 'th', 1],
          [:T_TEXT, 'foo', 1],
          [:T_ELEM_END, nil, 1],
          [:T_ELEM_END, nil, 1],
          [:T_ELEM_NAME, 'tbody', 1],
          [:T_TEXT, 'bar', 1],
          [:T_ELEM_END, nil, 1]
        ]
      end
    end
  end
end
