require 'spec_helper'

describe Oga::Lexer do
  context 'comments' do
    example 'lex a comment' do
      lex('<!-- foo -->').should == [
        [:T_COMMENT_START, '<!--', 1, 1],
        [:T_TEXT, ' foo ', 1, 5],
        [:T_COMMENT_END, '-->', 1, 10]
      ]
    end

    example 'lex a comment containing --' do
      lex('<!-- -- -->').should == [
        [:T_COMMENT_START, '<!--', 1, 1],
        [:T_TEXT, ' -- ', 1, 5],
        [:T_COMMENT_END, '-->', 1, 9]
      ]
    end

    example 'lex a comment containing ->' do
      lex('<!-- -> -->').should == [
        [:T_COMMENT_START, '<!--', 1, 1],
        [:T_TEXT, ' -> ', 1, 5],
        [:T_COMMENT_END, '-->', 1, 9]
      ]
    end
  end
end
