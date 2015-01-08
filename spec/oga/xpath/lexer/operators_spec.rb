require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'operators' do
    it 'lexes the pipe operator' do
      lex_xpath('|').should == [[:T_PIPE, nil]]
    end

    it 'lexes the and operator' do
      lex_xpath(' and ').should == [[:T_AND, nil]]
    end

    it 'lexes the or operator' do
      lex_xpath(' or ').should == [[:T_OR, nil]]
    end

    it 'lexes the plus operator' do
      lex_xpath('+').should == [[:T_ADD, nil]]
    end

    it 'lexes the div operator' do
      lex_xpath(' div ').should == [[:T_DIV, nil]]
    end

    it 'lexes the mod operator' do
      lex_xpath(' mod ').should == [[:T_MOD, nil]]
    end

    it 'lexes the equals operator' do
      lex_xpath('=').should == [[:T_EQ, nil]]
    end

    it 'lexes the not-equals operator' do
      lex_xpath('!=').should == [[:T_NEQ, nil]]
    end

    it 'lexes the lower-than operator' do
      lex_xpath('<').should == [[:T_LT, nil]]
    end

    it 'lexes the greater-than operator' do
      lex_xpath('>').should == [[:T_GT, nil]]
    end

    it 'lexes the lower-or-equal operator' do
      lex_xpath('<=').should == [[:T_LTE, nil]]
    end

    it 'lexes the greater-or-equal operator' do
      lex_xpath('>=').should == [[:T_GTE, nil]]
    end

    it 'lexes the mul operator' do
      lex_xpath(' * ').should == [[:T_MUL, nil]]
    end

    it 'lexes the subtraction operator' do
      lex_xpath(' - ').should == [[:T_SUB, nil]]
    end
  end
end
