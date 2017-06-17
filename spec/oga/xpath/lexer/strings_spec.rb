require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'strings' do
    it 'lexes a double quoted string' do
      expect(lex_xpath('"foo"')).to eq([[:T_STRING, 'foo']])
    end

    it 'lexes a single quoted string' do
      expect(lex_xpath("'foo'")).to eq([[:T_STRING, 'foo']])
    end

    it 'lexes an empty double quoted string' do
      expect(lex_xpath('""')).to eq([[:T_STRING, '']])
    end

    it 'lexes an empty single quoted string' do
      expect(lex_xpath("''")).to eq([[:T_STRING, '']])
    end
  end
end
