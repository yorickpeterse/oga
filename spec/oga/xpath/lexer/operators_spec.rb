require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'operators' do
    it 'lexes the pipe operator' do
      expect(lex_xpath('|')).to eq([[:T_PIPE, nil]])
    end

    it 'lexes the and operator' do
      expect(lex_xpath(' and ')).to eq([[:T_AND, nil]])
    end

    it 'lexes the or operator' do
      expect(lex_xpath(' or ')).to eq([[:T_OR, nil]])
    end

    it 'lexes the plus operator' do
      expect(lex_xpath('+')).to eq([[:T_ADD, nil]])
    end

    it 'lexes the div operator' do
      expect(lex_xpath(' div ')).to eq([[:T_DIV, nil]])
    end

    it 'lexes the mod operator' do
      expect(lex_xpath(' mod ')).to eq([[:T_MOD, nil]])
    end

    it 'lexes the equals operator' do
      expect(lex_xpath('=')).to eq([[:T_EQ, nil]])
    end

    it 'lexes the not-equals operator' do
      expect(lex_xpath('!=')).to eq([[:T_NEQ, nil]])
    end

    it 'lexes the lower-than operator' do
      expect(lex_xpath('<')).to eq([[:T_LT, nil]])
    end

    it 'lexes the greater-than operator' do
      expect(lex_xpath('>')).to eq([[:T_GT, nil]])
    end

    it 'lexes the lower-or-equal operator' do
      expect(lex_xpath('<=')).to eq([[:T_LTE, nil]])
    end

    it 'lexes the greater-or-equal operator' do
      expect(lex_xpath('>=')).to eq([[:T_GTE, nil]])
    end

    it 'lexes the mul operator' do
      expect(lex_xpath(' * ')).to eq([[:T_MUL, nil]])
    end

    it 'lexes the subtraction operator' do
      expect(lex_xpath(' - ')).to eq([[:T_SUB, nil]])
    end
  end
end
