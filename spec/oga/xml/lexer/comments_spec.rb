require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'comments' do
    it 'lexes a comment' do
      expect(lex('<!-- foo -->')).to eq([
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, ' foo ', 1],
        [:T_COMMENT_END, nil, 1]
      ])
    end

    it 'lexes a comment containing -' do
      expect(lex('<!-- - -->')).to eq([
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, ' ', 1],
        [:T_COMMENT_BODY, '-', 1],
        [:T_COMMENT_BODY, ' ', 1],
        [:T_COMMENT_END, nil, 1],
      ])
    end

    it 'lexes a comment containing --' do
      expect(lex('<!-- -- -->')).to eq([
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, ' ', 1],
        [:T_COMMENT_BODY, '-', 1],
        [:T_COMMENT_BODY, '-', 1],
        [:T_COMMENT_BODY, ' ', 1],
        [:T_COMMENT_END,  nil, 1]
      ])
    end

    it 'lexes a comment containing ->' do
      expect(lex('<!-- -> -->')).to eq([
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, ' ', 1],
        [:T_COMMENT_BODY, '-', 1],
        [:T_COMMENT_BODY, '> ', 1],
        [:T_COMMENT_END, nil, 1]
      ])
    end

    it 'lexes a comment followed by text' do
      expect(lex('<!---->foo')).to eq([
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_END, nil, 1],
        [:T_TEXT, 'foo', 1]
      ])
    end

    it 'lexes text followed by a comment' do
      expect(lex('foo<!---->')).to eq([
        [:T_TEXT, 'foo', 1],
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_END, nil, 1]
      ])
    end

    it 'lexes an element followed by a comment' do
      expect(lex('<p></p><!---->')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1],
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_END, nil, 1]
      ])
    end

    it 'lexes two comments following each other' do
      expect(lex('<a><!--foo--><b><!--bar--></b></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, 'foo', 1],
        [:T_COMMENT_END, nil, 1],
        [:T_ELEM_NAME, 'b', 1],
        [:T_COMMENT_START, nil, 1],
        [:T_COMMENT_BODY, 'bar', 1],
        [:T_COMMENT_END, nil, 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    describe 'using an IO as input' do
      it 'lexes a comment containing a newline after the open tag' do
        expect(lex_stringio("<!--\nfoo-->")).to eq([
          [:T_COMMENT_START, nil, 1],
          [:T_COMMENT_BODY, "\n", 1],
          [:T_COMMENT_BODY, "foo", 2],
          [:T_COMMENT_END, nil, 2]
        ])
      end

      it 'lexes a comment containing a newline before the closing tag' do
        expect(lex_stringio("<!--foo\n-->")).to eq([
          [:T_COMMENT_START, nil, 1],
          [:T_COMMENT_BODY, "foo\n", 1],
          [:T_COMMENT_END, nil, 2]
        ])
      end

      it 'lexes a comment with the body surrounded by newlines' do
        expect(lex_stringio("<!--\nfoo\n-->")).to eq([
          [:T_COMMENT_START, nil, 1],
          [:T_COMMENT_BODY, "\n", 1],
          [:T_COMMENT_BODY, "foo\n", 2],
          [:T_COMMENT_END, nil, 3]
        ])
      end
    end
  end
end
