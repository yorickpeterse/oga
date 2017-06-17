require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'predicates' do
    it 'lexes a path containing a simple predicate' do
      expect(lex_css('foo[bar]')).to eq([
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_IDENT, 'bar'],
        [:T_RBRACK, nil]
      ])
    end
  end
end
