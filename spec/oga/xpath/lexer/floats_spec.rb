require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'floats' do
    example 'lex a float' do
      lex_xpath('10.0').should == [[:T_FLOAT, 10.0]]
    end

    example 'lex a negative float' do
      lex_xpath('-10.0').should == [[:T_FLOAT, -10.0]]
    end
  end
end
