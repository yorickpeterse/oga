require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'strings' do
    it 'lexes a double quoted string' do
      lex_xpath('"foo"').should == [[:T_STRING, 'foo']]
    end

    it 'lexes a single quoted string' do
      lex_xpath("'foo'").should == [[:T_STRING, 'foo']]
    end

    it 'lexes an empty double quoted string' do
      lex_xpath('""').should == [[:T_STRING, '']]
    end

    it 'lexes an empty single quoted string' do
      lex_xpath("''").should == [[:T_STRING, '']]
    end
  end
end
