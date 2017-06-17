require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'predicates' do
    it 'lexes a simple predicate expression' do
      expect(lex_xpath('/foo[bar]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_IDENT, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate that checks for equality' do
      expect(lex_xpath('/foo[@bar="baz"]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'bar'],
        [:T_EQ, nil],
        [:T_STRING, 'baz'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate that user an integer' do
      expect(lex_xpath('/foo[1]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_INT, 1],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate that uses a float' do
      expect(lex_xpath('/foo[1.5]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_FLOAT, 1.5],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate using a function' do
      expect(lex_xpath('/foo[bar()]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_IDENT, 'bar'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate expression using the div operator' do
      expect(lex_xpath('/div[@number=4 div 2]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'div'],
        [:T_LBRACK, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'number'],
        [:T_EQ, nil],
        [:T_INT, 4],
        [:T_DIV, nil],
        [:T_INT, 2],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate expression using the * operator' do
      expect(lex_xpath('/div[@number=4 * 2]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'div'],
        [:T_LBRACK, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'number'],
        [:T_EQ, nil],
        [:T_INT, 4],
        [:T_MUL, nil],
        [:T_INT, 2],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate expression using axes' do
      expect(lex_xpath('/div[/foo/bar]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'div'],
        [:T_LBRACK, nil],
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_SLASH, nil],
        [:T_IDENT, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a predicate expression using a wildcard' do
      expect(lex_xpath('/div[/foo/*]')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'div'],
        [:T_LBRACK, nil],
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_SLASH, nil],
        [:T_IDENT, '*'],
        [:T_RBRACK, nil]
      ])
    end
  end
end
