require 'spec_helper'

describe Oga::Lexer do
  context 'elements' do
    example 'lex an opening element' do
      lex('<p>').should == [
        [:T_ELEM_OPEN, 'p', 1, 1]
      ]
    end

    example 'lex an opening an closing element' do
      lex('<p></p>').should == [
        [:T_ELEM_OPEN, 'p', 1, 1],
        [:T_ELEM_CLOSE, 'p', 1, 4]
      ]
    end

    example 'lex a paragraph element with text inside it' do
      lex('<p>Hello</p>').should == [
        [:T_ELEM_OPEN, 'p', 1, 1],
        [:T_TEXT, 'Hello', 1, 4],
        [:T_ELEM_CLOSE, 'p', 1, 9]
      ]
    end

    example 'lex a paragraph element with attributes' do
      lex('<p class="foo">Hello</p>').should == [
        [:T_ELEM_OPEN, 'p', 1, 1],
        [:T_ATTR, 'class', 1, 4],
        [:T_STRING, 'foo', 1, 10],
        [:T_TEXT, 'Hello', 1, 15],
        [:T_ELEM_CLOSE, 'p', 1, 20]
      ]
    end
  end

  context 'nested elements' do
    example 'lex a nested element' do
      lex('<p><a></a></p>').should == [
        [:T_ELEM_OPEN, 'p', 1, 1],
        [:T_ELEM_OPEN, 'a', 1, 4],
        [:T_ELEM_CLOSE, 'a', 1, 7],
        [:T_ELEM_CLOSE, 'p', 1, 11]
      ]
    end

    example 'lex nested elements and text nodes' do
      lex('<p>Foo<a>bar</a>baz</p>').should == [
        [:T_ELEM_OPEN, 'p', 1, 1],
        [:T_TEXT, 'Foo', 1, 4],
        [:T_ELEM_OPEN, 'a', 1, 7],
        [:T_TEXT, 'bar', 1, 10],
        [:T_ELEM_CLOSE, 'a', 1, 13],
        [:T_TEXT, 'baz', 1, 17],
        [:T_ELEM_CLOSE, 'p', 1, 20]
      ]
    end
  end
end
