require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <tr> elements' do
    it 'lexes two unclosed <tr> elements following each other as separate elements' do
      expect(lex_html('<tr>foo<tr>bar')).to eq([
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <td> followed an unclosed <tr> as a child element' do
      expect(lex_html('<tr><td>foo')).to eq([
        [:T_ELEM_NAME, 'tr', 1],
        [:T_ELEM_NAME, 'td', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <th> followed an unclosed <tr> as a child element' do
      expect(lex_html('<tr><th>foo')).to eq([
        [:T_ELEM_NAME, 'tr', 1],
        [:T_ELEM_NAME, 'th', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tr> element containing a <script> element' do
      expect(lex_html('<tr><script>foo</script></tr>')).to eq([
        [:T_ELEM_NAME, 'tr', 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tr> element containing a <template> element' do
      expect(lex_html('<tr><template>foo</template></tr>')).to eq([
        [:T_ELEM_NAME, 'tr', 1],
        [:T_ELEM_NAME, 'template', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
