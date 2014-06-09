require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'operators' do
    example 'lex the pipe operator' do
      lex_xpath('|').should == [[:T_PIPE, nil]]
    end

    example 'lex the and operator' do
      lex_xpath(' and ').should == [[:T_AND, nil]]
    end

    example 'lex the or operator' do
      lex_xpath(' or ').should == [[:T_OR, nil]]
    end

    example 'lex the plus operator' do
      lex_xpath('+').should == [[:T_ADD, nil]]
    end

    example 'lex the div operator' do
      lex_xpath(' div ').should == [[:T_DIV, nil]]
    end

    example 'lex the mod operator' do
      lex_xpath(' mod ').should == [[:T_MOD, nil]]
    end

    example 'lex the equals operator' do
      lex_xpath('=').should == [[:T_EQ, nil]]
    end

    example 'lex the not-equals operator' do
      lex_xpath('!=').should == [[:T_NEQ, nil]]
    end

    example 'lex the lower-than operator' do
      lex_xpath('<').should == [[:T_LT, nil]]
    end

    example 'lex the greater-than operator' do
      lex_xpath('>').should == [[:T_GT, nil]]
    end

    example 'lex the lower-or-equal operator' do
      lex_xpath('<=').should == [[:T_LTE, nil]]
    end

    example 'lex the greater-or-equal operator' do
      lex_xpath('>=').should == [[:T_GTE, nil]]
    end

    example 'lex the mul operator' do
      lex_xpath(' * ').should == [[:T_MUL, nil]]
    end

    example 'lex the subtraction operator' do
      lex_xpath(' - ').should == [[:T_SUB, nil]]
    end
  end
end
