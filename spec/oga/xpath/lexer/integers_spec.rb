require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'integers' do
    example 'lex an integer' do
      lex_xpath('10').should == [[:T_INT, 10]]
    end

    example 'lex a negative integer' do
      lex_xpath('-10').should == [[:T_INT, -10]]
    end
  end
end
