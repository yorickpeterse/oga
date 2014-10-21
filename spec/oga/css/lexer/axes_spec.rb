require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'axes' do
    example 'lex the > axis' do
      lex_css('>').should == [[:T_CHILD, nil]]
    end

    example 'lex the expression "> y"' do
      lex_css('> y').should == [[:T_CHILD, nil], [:T_IDENT, 'y']]
    end

    example 'lex the expression "x > y"' do
      lex_css('x > y').should == [
        [:T_IDENT, 'x'],
        [:T_SPACE, nil],
        [:T_CHILD, nil],
        [:T_IDENT, 'y']
      ]
    end

    example 'lex the + axis' do
      lex_css('+').should == [[:T_FOLLOWING_DIRECT, nil]]
    end

    example 'lex the expression "+ y"' do
      lex_css('+ y').should == [[:T_FOLLOWING_DIRECT, nil], [:T_IDENT, 'y']]
    end

    example 'lex the expression "x + y"' do
      lex_css('x + y').should == [
        [:T_IDENT, 'x'],
        [:T_SPACE, nil],
        [:T_FOLLOWING_DIRECT, nil],
        [:T_IDENT, 'y']
      ]
    end

    example 'lex the ~ axis' do
      lex_css('~').should == [[:T_FOLLOWING, nil]]
    end

    example 'lex the expression "~ y"' do
      lex_css('~ y').should == [[:T_FOLLOWING, nil], [:T_IDENT, 'y']]
    end

    example 'lex the expression "x ~ y"' do
      lex_css('x ~ y').should == [
        [:T_IDENT, 'x'],
        [:T_SPACE, nil],
        [:T_FOLLOWING, nil],
        [:T_IDENT, 'y']
      ]
    end
  end
end
