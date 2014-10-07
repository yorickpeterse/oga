require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'axes' do
    example 'lex the > axis' do
      lex_css('>').should == [[:T_CHILD, nil]]
    end

    example 'lex the > axis with surrounding whitespace' do
      lex_css('>').should == [[:T_CHILD, nil]]
    end

    example 'lex the + axis' do
      lex_css('+').should == [[:T_FOLLOWING_DIRECT, nil]]
    end

    example 'lex the + axis with surrounding whitespace' do
      lex_css(' + ').should == [[:T_FOLLOWING_DIRECT, nil]]
    end

    example 'lex the ~ axis' do
      lex_css('~').should == [[:T_FOLLOWING, nil]]
    end

    example 'lex the ~ axis with surrounding whitespace' do
      lex_css(' ~ ').should == [[:T_FOLLOWING, nil]]
    end
  end
end
