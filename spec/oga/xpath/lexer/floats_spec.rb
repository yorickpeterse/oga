require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'floats' do
    it 'lexes a float' do
      expect(lex_xpath('10.0')).to eq([[:T_FLOAT, 10.0]])
    end

    it 'lexes a negative float' do
      expect(lex_xpath('-10.0')).to eq([[:T_FLOAT, -10.0]])
    end
  end
end
