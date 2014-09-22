require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'integers' do
    example 'lex an integer' do
      lex_css('10').should == [[:T_INT, 10]]
    end
  end
end
