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

    example 'lex the :nth-child pseudo class using "odd" as an argument' do
      lex_css(':nth-child(odd)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_IDENT, 'odd'],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex the :nth-child pseudo class using "2n+1" as an argument' do
      lex_css(':nth-child(2n+1)').should == [
        [:T_COLON, nil],
        [:T_IDENT, 'nth-child'],
        [:T_LPAREN, nil],
        [:T_INT, 2],
        [:T_NTH, 'n'],
        [:T_INT, 1],
        [:T_RPAREN, nil]
      ]
    end
  end
end
