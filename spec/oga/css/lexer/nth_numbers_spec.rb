require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'nth numbers' do
    example 'lex the 2n number' do
      lex_css('2n').should == [[:T_INT, 2], [:T_NTH, 'n']]
    end

    example 'lex the 2n+1 number' do
      lex_css('2n+1').should == [[:T_INT, 2], [:T_NTH, 'n'], [:T_INT, 1]]
    end

    example 'lex the 2n-1 number' do
      lex_css('2n-1').should == [[:T_INT, 2], [:T_NTH, 'n'], [:T_INT, -1]]
    end

    example 'lex the 2n -1 number' do
      lex_css('2n -1').should == [[:T_INT, 2], [:T_NTH, 'n'], [:T_INT, -1]]
    end

    example 'lex the -n number' do
      lex_css('-n').should == [[:T_NTH, '-n']]
    end

    example 'lex the +n number' do
      lex_css('+n').should == [[:T_NTH, '+n']]
    end
  end
end
