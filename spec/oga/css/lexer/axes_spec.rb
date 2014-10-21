require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'axes' do
    example 'lex the > axis' do
      lex_css('>').should == [[:T_GREATER, nil]]
    end

    example 'lex the expression "> y"' do
      lex_css('> y').should == [[:T_GREATER, nil], [:T_IDENT, 'y']]
    end

    example 'lex the expression "x > y"' do
      lex_css('x > y').should == [
        [:T_IDENT, 'x'],
        [:T_SPACE, nil],
        [:T_GREATER, nil],
        [:T_IDENT, 'y']
      ]
    end

    example 'lex the + axis' do
      lex_css('+').should == [[:T_PLUS, nil]]
    end

    example 'lex the expression "+ y"' do
      lex_css('+ y').should == [[:T_PLUS, nil], [:T_IDENT, 'y']]
    end

    example 'lex the expression "x + y"' do
      lex_css('x + y').should == [
        [:T_IDENT, 'x'],
        [:T_SPACE, nil],
        [:T_PLUS, nil],
        [:T_IDENT, 'y']
      ]
    end

    example 'lex the ~ axis' do
      lex_css('~').should == [[:T_TILDE, nil]]
    end

    example 'lex the expression "~ y"' do
      lex_css('~ y').should == [[:T_TILDE, nil], [:T_IDENT, 'y']]
    end

    example 'lex the expression "x ~ y"' do
      lex_css('x ~ y').should == [
        [:T_IDENT, 'x'],
        [:T_SPACE, nil],
        [:T_TILDE, nil],
        [:T_IDENT, 'y']
      ]
    end
  end
end
