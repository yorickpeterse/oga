require 'spec_helper'

describe Oga::Lexer do
  context 'cdata tags' do
    example 'lex a cdata tag' do
      lex('<![CDATA[foo]]>').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_BANG, '!', 1, 2],
        [:T_LBRACKET, '[', 1, 3],
        [:T_TEXT, 'CDATA', 1, 4],
        [:T_LBRACKET, '[', 1, 9],
        [:T_TEXT, 'foo', 1, 10],
        [:T_RBRACKET, ']', 1, 13],
        [:T_RBRACKET, ']', 1, 14],
        [:T_GREATER, '>', 1, 15],
      ]
    end
  end
end
