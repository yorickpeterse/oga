require 'spec_helper'

describe Oga::Lexer do
  context 'regular text' do
    example 'lex regular text' do
      lex('hello').should == [[:T_TEXT, 'hello', 1, 1]]
    end
  end

  context 'whitespace' do
    example 'lex regular whitespace' do
      lex(' ').should == [[:T_SPACE, ' ', 1, 1]]
    end

    example 'lex a newline' do
      lex("\n").should == [[:T_NEWLINE, "\n", 1, 1]]
    end

    example 'advance column numbers for spaces' do
      lex('  ').should == [
        [:T_SPACE, ' ', 1, 1],
        [:T_SPACE, ' ', 1, 2]
      ]
    end

    example 'advance line numbers for newlines' do
      lex("\n ").should == [
        [:T_NEWLINE, "\n", 1, 1],
        [:T_SPACE, ' ', 2, 1]
      ]
    end
  end

  context 'tags' do
    example 'lex an opening tag' do
      lex('<p>').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_TEXT, 'p', 1, 2],
        [:T_GREATER, '>', 1, 3]
      ]
    end

    example 'lex an opening tag with an attribute' do
      lex('<p title="Foo">').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_TEXT, 'p', 1, 2],
        [:T_SPACE, ' ', 1, 3],
        [:T_TEXT, 'title', 1, 4],
        [:T_EQUALS, '=', 1, 9],
        [:T_DQUOTE, '"', 1, 10],
        [:T_TEXT, 'Foo', 1, 11],
        [:T_DQUOTE, '"', 1, 14],
        [:T_GREATER, '>', 1, 15]
      ]
    end

    example 'lex a tag with text inside it' do
      lex('<p>Foo</p>').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_TEXT, 'p', 1, 2],
        [:T_GREATER, '>', 1, 3],
        [:T_TEXT, 'Foo', 1, 4],
        [:T_SMALLER, '<', 1, 7],
        [:T_SLASH, '/', 1, 8],
        [:T_TEXT, 'p', 1, 9],
        [:T_GREATER, '>', 1, 10]
      ]
    end

    example 'lex a tag with an attribute with a dash in it' do
      lex('<p foo-bar="baz">').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_TEXT, 'p', 1, 2],
        [:T_SPACE, ' ', 1, 3],
        [:T_TEXT, 'foo', 1, 4],
        [:T_DASH, '-', 1, 7],
        [:T_TEXT, 'bar', 1, 8],
        [:T_EQUALS, '=', 1, 11],
        [:T_DQUOTE, '"', 1, 12],
        [:T_TEXT, 'baz', 1, 13],
        [:T_DQUOTE, '"', 1, 16],
        [:T_GREATER, '>', 1, 17]
      ]
    end
  end

  context 'tags with namespaces' do
    example 'lex a tag with a dummy namespace' do
      lex('<foo:p></p>').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_TEXT, 'foo', 1, 2],
        [:T_COLON, ':', 1, 5],
        [:T_TEXT, 'p', 1, 6],
        [:T_GREATER, '>', 1, 7],
        [:T_SMALLER, '<', 1, 8],
        [:T_SLASH, '/', 1, 9],
        [:T_TEXT, 'p', 1, 10],
        [:T_GREATER, '>', 1, 11]
      ]
    end
  end

  context 'comments' do
    example 'lex a comment' do
      lex('<!-- foo -->').should == [
        [:T_SMALLER, '<', 1, 1],
        [:T_EXCLAMATION, '!', 1, 2],
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
