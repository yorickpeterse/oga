require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'function calls' do
    it 'lexes a function call without arguments' do
      lex_xpath('count()').should == [
        [:T_IDENT, 'count'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil]
      ]
    end

    it 'lexes a function call with a single argument' do
      lex_xpath('count(foo)').should == [
        [:T_IDENT, 'count'],
        [:T_LPAREN, nil],
        [:T_IDENT, 'foo'],
        [:T_RPAREN, nil]
      ]
    end

    it 'lexes a function call with two arguments' do
      lex_xpath('count(/foo, "bar")').should == [
        [:T_IDENT, 'count'],
        [:T_LPAREN, nil],
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_COMMA, nil],
        [:T_STRING, 'bar'],
        [:T_RPAREN, nil]
      ]
    end
  end
end
