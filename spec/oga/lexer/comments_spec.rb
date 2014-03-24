require 'spec_helper'

describe Oga::Lexer do
  context 'comments' do
    example 'lex a comment' do
      lex('<!-- foo -->').should == [
        [:T_COMMENT_START, '<!--', 1],
        [:T_TEXT, ' foo ', 1],
        [:T_COMMENT_END, '-->', 1]
      ]
    end

    example 'lex a comment containing --' do
      lex('<!-- -- -->').should == [
        [:T_COMMENT_START, '<!--', 1],
        [:T_TEXT, ' -- ', 1],
        [:T_COMMENT_END, '-->', 1]
      ]
    end

    example 'lex a comment containing ->' do
      lex('<!-- -> -->').should == [
        [:T_COMMENT_START, '<!--', 1],
        [:T_TEXT, ' -> ', 1],
        [:T_COMMENT_END, '-->', 1]
      ]
    end

    example 'lex a comment followed by text' do
      lex('<!---->foo').should == [
        [:T_COMMENT_START, '<!--', 1],
        [:T_COMMENT_END, '-->', 1],
        [:T_TEXT, 'foo', 1]
      ]
    end

    example 'lex text followed by a comment' do
      lex('foo<!---->').should == [
        [:T_TEXT, 'foo', 1],
        [:T_COMMENT_START, '<!--', 1],
        [:T_COMMENT_END, '-->', 1]
      ]
    end

    example 'lex an element followed by a comment' do
      lex('<p></p><!---->').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1],
        [:T_COMMENT_START, '<!--', 1],
        [:T_COMMENT_END, '-->', 1]
      ]
    end
  end
end
