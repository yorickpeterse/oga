require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'strings' do
    example 'lex a single quoted string' do
      lex_css("['foo']").should == [
        [:T_LBRACK, nil],
        [:T_STRING, 'foo'],
        [:T_RBRACK, nil]
      ]
    end

    example 'lex a double quoted string' do
      lex_css('["foo"]').should == [
        [:T_LBRACK, nil],
        [:T_STRING, 'foo'],
        [:T_RBRACK, nil]
      ]
    end
  end
end
