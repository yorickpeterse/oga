require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'axes' do
    it 'lexes the > axis' do
      expect(lex_css('>')).to eq([[:T_GREATER, nil]])
    end

    it 'lexes the expression "> y"' do
      expect(lex_css('> y')).to eq([[:T_GREATER, nil], [:T_IDENT, 'y']])
    end

    it 'lexes the expression "x > y"' do
      expect(lex_css('x > y')).to eq([
        [:T_IDENT, 'x'],
        [:T_GREATER, nil],
        [:T_IDENT, 'y']
      ])
    end

    it 'lexes the expression "x>y"' do
      expect(lex_css('x>y')).to eq(lex_css('x > y'))
    end

    it 'lexes the + axis' do
      expect(lex_css('+')).to eq([[:T_PLUS, nil]])
    end

    it 'lexes the expression "+ y"' do
      expect(lex_css('+ y')).to eq([[:T_PLUS, nil], [:T_IDENT, 'y']])
    end

    it 'lexes the expression "x + y"' do
      expect(lex_css('x + y')).to eq([
        [:T_IDENT, 'x'],
        [:T_PLUS, nil],
        [:T_IDENT, 'y']
      ])
    end

    it 'lexes the expression "x+y"' do
      expect(lex_css('x+y')).to eq(lex_css('x + y'))
    end

    it 'lexes the ~ axis' do
      expect(lex_css('~')).to eq([[:T_TILDE, nil]])
    end

    it 'lexes the expression "~ y"' do
      expect(lex_css('~ y')).to eq([[:T_TILDE, nil], [:T_IDENT, 'y']])
    end

    it 'lexes the expression "x ~ y"' do
      expect(lex_css('x ~ y')).to eq([
        [:T_IDENT, 'x'],
        [:T_TILDE, nil],
        [:T_IDENT, 'y']
      ])
    end

    it 'lexes the expression "x~y"' do
      expect(lex_css('x~y')).to eq(lex_css('x ~ y'))
    end
  end
end
