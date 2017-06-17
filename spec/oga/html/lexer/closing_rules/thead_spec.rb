require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <thead> elements' do
    it 'lexes two unclosed <thead> elements following each other as separate elements' do
      expect(lex_html('<thead>foo<thead>bar')).to eq([
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <thead> followed by a <tbody> as separate elements' do
      expect(lex_html('<thead>foo<tbody>bar')).to eq([
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'tbody', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <tr> following an unclosed <thead> as a child element' do
      expect(lex_html('<thead><tr>foo')).to eq([
        [:T_ELEM_NAME, 'thead', 1],
        [:T_ELEM_NAME, 'tr', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <thead> element containing a <script> element' do
      expect(lex_html('<thead><script>foo</script></thead>')).to eq([
        [:T_ELEM_NAME, 'thead', 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <thead> element containing a <template> element' do
      expect(lex_html('<thead><template>foo</template></thead>')).to eq([
        [:T_ELEM_NAME, 'thead', 1],
        [:T_ELEM_NAME, 'template', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
