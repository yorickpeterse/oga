require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML style elements' do
    it 'lexes an empty <style> tag' do
      expect(lex_html('<style></style>')).to eq([
        [:T_ELEM_NAME, 'style', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'treats the content of a style tag as plain text' do
      expect(lex_html('<style>foo <bar</style>')).to eq([
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, 'foo ', 1],
        [:T_TEXT, '<', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'treats script tags inside style tags as text' do
      expect(lex_html('<style><script></script></style>')).to eq([
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, '<', 1],
        [:T_TEXT, 'script>', 1],
        [:T_TEXT, '<', 1],
        [:T_TEXT, '/script>', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a multi-line <style> tag using a String as the input' do
      expect(lex_html("<style>foo\nbar</style>")).to eq([
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, "foo\nbar", 1],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes a multi-line <style> tag using an IO as the input' do
      expect(lex_stringio("<style>foo\nbar</style>", :html => true)).to eq([
        [:T_ELEM_NAME, 'style', 1],
        [:T_TEXT, "foo\n", 1],
        [:T_TEXT, 'bar', 2],
        [:T_ELEM_END, nil, 2]
      ])
    end
  end
end
