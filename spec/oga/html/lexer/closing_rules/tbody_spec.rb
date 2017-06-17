require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <tbody> elements' do
    it 'lexes two unclosed <tbody> elements following each other as separate elements' do
      expect(lex_html('<tbody>foo<tbody>bar')).to eq([
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <tbody> followed by a <tfoot> as separate elements' do
      expect(lex_html('<tbody>foo<tfoot>bar')).to eq([
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tfoot', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tr> following an unclosed <tbody> as a child element' do
      expect(lex_html('<tbody><tr>foo')).to eq([
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tbody> element containing a <script> element' do
      expect(lex_html('<tbody><script>foo</script></tbody>')).to eq([
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tbody> element containing a <template> element' do
      expect(lex_html('<tbody><template>foo</template></tbody>')).to eq([
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_ELEM_NAME, 'template', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
