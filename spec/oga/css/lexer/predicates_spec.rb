require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'predicates' do
    example 'lex a path containing a simple predicate' do
      lex_css('foo[bar]').should == [
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_IDENT, 'bar'],
        [:T_RBRACK, nil]
      ]
    end
  end
end
