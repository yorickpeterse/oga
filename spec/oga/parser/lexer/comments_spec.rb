require 'spec_helper'

describe Oga::Lexer do
  context 'comments' do
    example 'lex a comment' do
      lex('<!-- foo -->').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_BANG, '!', 1, 2],
        [:T_DASH, '-', 1, 3],
        [:T_DASH, '-', 1, 4],
        [:T_SPACE, ' ', 1, 5],
        [:T_TEXT, 'foo', 1, 6],
        [:T_SPACE, ' ', 1, 9],
        [:T_DASH, '-', 1, 10],
        [:T_DASH, '-', 1, 11],
        [:T_GREATER, '>', 1, 12]
      ]
    end
  end
end
