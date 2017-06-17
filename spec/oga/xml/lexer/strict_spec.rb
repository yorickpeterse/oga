require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'lexing XML using strict mode' do
    it 'does not automatically insert missing closing tags' do
      expect(lex('<foo>bar', :strict => true)).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_TEXT, 'bar', 1]
      ])
    end
  end
end
