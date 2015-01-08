require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'integers' do
    it 'lexes an integer' do
      lex_xpath('10').should == [[:T_INT, 10]]
    end

    it 'lexes a negative integer' do
      lex_xpath('-10').should == [[:T_INT, -10]]
    end
  end
end
