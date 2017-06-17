require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'pseudo classes' do
    it 'lexes the :root pseudo class' do
      expect(lex_css(':root')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'root']
      ])
    end

    it 'lexes the :nth-child pseudo class' do
      expect(lex_css(':nth-child(1)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child pseudo class with extra whitespace' do
      expect(lex_css(':nth-child(  1)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(odd) pseudo class' do
      expect(lex_css(':nth-child(odd)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_ODD, nil],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(even) pseudo class' do
      expect(lex_css(':nth-child(even)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_EVEN, nil],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(n) pseudo class' do
      expect(lex_css(':nth-child(n)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_NTH, nil],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(-n) pseudo class' do
      expect(lex_css(':nth-child(-n)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_MINUS, nil],
        [:T_NTH, nil],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(2n) pseudo class' do
      expect(lex_css(':nth-child(2n)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, nil],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(2n+1) pseudo class' do
      expect(lex_css(':nth-child(2n+1)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, nil],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(2n-1) pseudo class' do
      expect(lex_css(':nth-child(2n-1)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, nil],
        [:T_INT, -1],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :nth-child(-2n-1) pseudo class' do
      expect(lex_css(':nth-child(-2n-1)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, -2],
        [:T_NTH, nil],
        [:T_INT, -1],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :lang(fr) pseudo class' do
      expect(lex_css(':lang(fr)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'lang'],
        [:T_LPAREN, nil],
        [:T_IDENT, 'fr'],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes the :not(#foo) pseudo class' do
      expect(lex_css(':not(#foo)')).to eq([
        [:T_COLON, nil],
        [:T_IDENT, 'not'],
        [:T_LPAREN, nil],
        [:T_HASH, nil],
        [:T_IDENT, 'foo'],
        [:T_RPAREN, nil]
      ])
    end
  end
end
