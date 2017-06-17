require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'using HTML <body> elements' do
    it 'lexes an unclosed <body> followed by a <head> as separate elements' do
      expect(lex_html('<body>foo<head>bar')).to eq([
        [:T_ELEM_NAME, 'body', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'head', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an unclosed <body> followed by a <body> as separate elements' do
      expect(lex_html('<body>foo<body>bar')).to eq([
        [:T_ELEM_NAME, 'body', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_NAME, 'body', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a <p> following an unclosed <body> as a child element' do
      expect(lex_html('<body><p>foo</body>')).to eq([
        [:T_ELEM_NAME, 'body', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
