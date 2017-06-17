require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'operators' do
    it 'lexes the = operator' do
      expect(lex_css('[foo="bar"]')).to eq([
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_EQ, nil],
        [:T_STRING, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes the ~= operator' do
      expect(lex_css('[foo~="bar"]')).to eq([
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_SPACE_IN, nil],
        [:T_STRING, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes the ^= operator' do
      expect(lex_css('[foo^="bar"]')).to eq([
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_STARTS_WITH, nil],
        [:T_STRING, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes the $= operator' do
      expect(lex_css('[foo$="bar"]')).to eq([
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_ENDS_WITH, nil],
        [:T_STRING, 'bar'],
        [:T_RBRACK, nil],
      ])
    end

    it 'lexes the *= operator' do
      expect(lex_css('[foo*="bar"]')).to eq([
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_IN, nil],
        [:T_STRING, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes the |= operator' do
      expect(lex_css('[foo|="bar"]')).to eq([
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_HYPHEN_IN, nil],
        [:T_STRING, 'bar'],
        [:T_RBRACK, nil]
      ])
    end

    it 'lexes the = operator surrounded by whitespace' do
      expect(lex_css('[foo = "bar"]')).to eq(lex_css('[foo="bar"]'))
    end

    it 'lexes the ~= operator surrounded by whitespace' do
      expect(lex_css('[foo ~= "bar"]')).to eq(lex_css('[foo~="bar"]'))
    end

    it 'lexes the ^= operator surrounded by whitespace' do
      expect(lex_css('[foo ^= "bar"]')).to eq(lex_css('[foo^="bar"]'))
    end

    it 'lexes the $= operator surrounded by whitespace' do
      expect(lex_css('[foo $= "bar"]')).to eq(lex_css('[foo$="bar"]'))
    end

    it 'lexes the *= operator surrounded by whitespace' do
      expect(lex_css('[foo *= "bar"]')).to eq(lex_css('[foo*="bar"]'))
    end

    it 'lexes the |= operator surrounded by whitespace' do
      expect(lex_css('[foo |= "bar"]')).to eq(lex_css('[foo|="bar"]'))
    end
  end
end
