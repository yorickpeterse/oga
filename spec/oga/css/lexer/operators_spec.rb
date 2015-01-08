require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'operators' do
    it 'lexes the = operator' do
      lex_css('[=]').should == [
        [:T_LBRACK, nil],
        [:T_EQ, nil],
        [:T_RBRACK, nil]
      ]
    end

    it 'lexes the ~= operator' do
      lex_css('[~=]').should == [
        [:T_LBRACK, nil],
        [:T_SPACE_IN, nil],
        [:T_RBRACK, nil]
      ]
    end

    it 'lexes the ^= operator' do
      lex_css('[^=]').should == [
        [:T_LBRACK, nil],
        [:T_STARTS_WITH, nil],
        [:T_RBRACK, nil]
      ]
    end

    it 'lexes the $= operator' do
      lex_css('[$=]').should == [
        [:T_LBRACK, nil],
        [:T_ENDS_WITH, nil],
        [:T_RBRACK, nil],
      ]
    end

    it 'lexes the *= operator' do
      lex_css('[*=]').should == [
        [:T_LBRACK, nil],
        [:T_IN, nil],
        [:T_RBRACK, nil]
      ]
    end

    it 'lexes an identifier followed by the *= operator' do
      lex_css('[foo *=]').should == [
        [:T_LBRACK, nil],
        [:T_IDENT, 'foo'],
        [:T_IN, nil],
        [:T_RBRACK, nil]
      ]
    end

    it 'lexes the |= operator' do
      lex_css('[|=]').should == [
        [:T_LBRACK, nil],
        [:T_HYPHEN_IN, nil],
        [:T_RBRACK, nil]
      ]
    end
  end
end
