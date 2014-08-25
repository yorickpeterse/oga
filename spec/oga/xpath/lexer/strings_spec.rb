require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'strings' do
    example 'lex a double quoted string' do
      lex_xpath('"foo"').should == [[:T_STRING, 'foo']]
    end

    example 'lex a single quoted string' do
      lex_xpath("'foo'").should == [[:T_STRING, 'foo']]
    end

    example 'lex an empty double quoted string' do
      lex_xpath('""').should == [[:T_STRING, '']]
    end

    example 'lex an empty single quoted string' do
      lex_xpath("''").should == [[:T_STRING, '']]
    end
  end
end
