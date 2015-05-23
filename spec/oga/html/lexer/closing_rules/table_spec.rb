require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <table> elements' do
    it 'lexes two unclosed <table> elements following each other as separate elements' do
      lex_html('<table>foo<table>bar').should == [
        [:T_ELEM_NAME, 'table', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'table', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <table> element containing a <thead> element' do
      lex_html('<table><thead>foo</thead></table>').should == [
        [:T_ELEM_NAME, 'table', 1],
        [:T_ELEM_NAME, 'thead', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <table> element containing a <script> element' do
      lex_html('<table><script>foo</script></table>').should == [
        [:T_ELEM_NAME, 'table', 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a <table> element containing a <template> element' do
      lex_html('<table><template>foo</template></table>').should == [
        [:T_ELEM_NAME, 'table', 1],
        [:T_ELEM_NAME, 'template', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
