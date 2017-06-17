require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'strings' do
    it 'lexes a single quoted string' do
      expect(lex_css("['foo']")).to eq([
        [:T_LBRACK, nil],
        [:T_STRING, 'foo'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes a double quoted string' do
      expect(lex_css('["foo"]')).to eq([
        [:T_LBRACK, nil],
        [:T_STRING, 'foo'],
        [:T_RBRACK, nil]
      ])
    end
  end
end
