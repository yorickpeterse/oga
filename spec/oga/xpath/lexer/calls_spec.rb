require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'function calls' do
    it 'lexes a function call without arguments' do
      expect(lex_xpath('count()')).to eq([
        [:T_IDENT, 'count'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes a function call with a single argument' do
      expect(lex_xpath('count(foo)')).to eq([
        [:T_IDENT, 'count'],
        [:T_LPAREN, nil],
        [:T_IDENT, 'foo'],
        [:T_RPAREN, nil]
      ])
    end

    it 'lexes a function call with two arguments' do
      expect(lex_xpath('count(/foo, "bar")')).to eq([
        [:T_IDENT, 'count'],
        [:T_LPAREN, nil],
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_COMMA, nil],
        [:T_STRING, 'bar'],
        [:T_RPAREN, nil]
      ])
    end
  end
end
