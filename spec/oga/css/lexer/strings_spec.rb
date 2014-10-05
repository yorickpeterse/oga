require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'strings' do
    example 'lex a single quoted string' do
      lex_css("'foo'").should == [[:T_STRING, 'foo']]
    end

    example 'lex a double quoted string' do
      lex_css('"foo"').should == [[:T_STRING, 'foo']]
    end
  end
end
