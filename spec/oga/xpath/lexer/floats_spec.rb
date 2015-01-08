require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'floats' do
    it 'lexes a float' do
      lex_xpath('10.0').should == [[:T_FLOAT, 10.0]]
    end

    it 'lexes a negative float' do
      lex_xpath('-10.0').should == [[:T_FLOAT, -10.0]]
    end
  end
end
