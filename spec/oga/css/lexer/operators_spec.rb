require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'operators' do
    example 'lex the = operator' do
      lex_css('=').should == [[:T_EQ, nil]]
    end

    example 'lex the ~= operator' do
      lex_css('~=').should == [[:T_SPACE_IN, nil]]
    end

    example 'lex the ^= operator' do
      lex_css('^=').should == [[:T_STARTS_WITH, nil]]
    end

    example 'lex the $= operator' do
      lex_css('$=').should == [[:T_ENDS_WITH, nil]]
    end

    example 'lex the *= operator' do
      lex_css('*=').should == [[:T_IN, nil]]
    end

    example 'lex an identifier followed by the *= operator' do
      lex_css('foo *=').should == [
        [:T_IDENT, 'foo'],
        [:T_SPACE, nil],
        [:T_IN, nil]
      ]
    end

    example 'lex the |= operator' do
      lex_css('|=').should == [[:T_HYPHEN_IN, nil]]
    end

    example 'lex the > operator' do
      lex_css('>').should == [[:T_CHILD, nil]]
    end

    example 'lex the + operator' do
      lex_css('+').should == [[:T_FOLLOWING_DIRECT, nil]]
    end

    example 'lex the ~ operator' do
      lex_css('~').should == [[:T_FOLLOWING, nil]]
    end
  end
end
