require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'pseudo classes' do
    example 'lex the :root pseudo class' do
      lex_css(':root').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'root']
      ]
    end

    example 'lex the :nth-child pseudo class' do
      lex_css(':nth-child(1)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child pseudo class with extra whitespace' do
      lex_css(':nth-child(  1)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(odd) pseudo class' do
      lex_css(':nth-child(odd)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_ODD, nil],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(even) pseudo class' do
      lex_css(':nth-child(even)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_EVEN, nil],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(n) pseudo class' do
      lex_css(':nth-child(n)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_NTH, nil],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(-n) pseudo class' do
      lex_css(':nth-child(-n)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_MINUS, nil],
        [:T_NTH, nil],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(2n) pseudo class' do
      lex_css(':nth-child(2n)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, nil],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(2n+1) pseudo class' do
      lex_css(':nth-child(2n+1)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, nil],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(2n-1) pseudo class' do
      lex_css(':nth-child(2n-1)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, nil],
        [:T_INT, -1],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child(-2n-1) pseudo class' do
      lex_css(':nth-child(-2n-1)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, -2],
        [:T_NTH, nil],
        [:T_INT, -1],
        [:T_RPAREN, nil]
      ]
    end
  end
end
