require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'axes' do
    example 'lex an axis using the full syntax form' do
      lex_xpath('/parent::node()').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_IDENT, 'node'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil]
      ]
    end

    example 'lex an axis using the short syntax form' do
      lex_xpath('/..').should == [[:T_SLASH, nil], [:T_AXIS, 'parent']]
    end
  end
end
