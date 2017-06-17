require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'invalid elements' do
    it 'adds missing closing tags' do
      expect(lex('<a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'ignores closing tags without opening tags' do
      expect(lex('</a>')).to eq([])
    end

    it 'ignores excessive closing tags' do
      expect(lex('<a></a></b>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
