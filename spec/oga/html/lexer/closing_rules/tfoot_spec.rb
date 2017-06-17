require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <tfoot> elements' do
    it 'lexes two unclosed <tfoot> elements following each other as separate elements' do
      expect(lex_html('<tfoot>foo<tfoot>bar')).to eq([
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <tfoot> followed by a <tbody> as separate elements' do
      expect(lex_html('<tfoot>foo<tbody>bar')).to eq([
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tr> following an unclosed <tfoot> as a child element' do
      expect(lex_html('<tfoot><tr>foo')).to eq([
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tfoot> element containing a <script> element' do
      expect(lex_html('<tfoot><script>foo</script></tfoot>')).to eq([
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tfoot> element containing a <template> element' do
      expect(lex_html('<tfoot><template>foo</template></tfoot>')).to eq([
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_ELEM_NAME, 'template', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
