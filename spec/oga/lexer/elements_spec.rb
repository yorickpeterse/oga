require 'spec_helper'

describe Oga::Lexer do
  context 'elements' do
    example 'lex an opening element' do
      lex('<p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1]
      ]
    end

    example 'lex an opening an closing element' do
      lex('<p></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex a paragraph element with text inside it' do
      lex('<p>Hello</p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'Hello', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex text followed by a paragraph element' do
      lex('Foo<p>').should == [
        [:T_TEXT, 'Foo', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1]
      ]
    end

    example 'lex an element with a newline in the open tag' do
      lex("<p\n></p>").should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 2]
      ]
    end
  end

  context 'elements with attributes' do
    example 'lex an element with an attribute without a value' do
      lex('<p foo></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex a paragraph element with attributes' do
      lex('<p class="foo">Hello</p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING, 'foo', 1],
        [:T_TEXT, 'Hello', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end

  context 'nested elements' do
    example 'lex a nested element' do
      lex('<p><a></a></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex nested elements and text nodes' do
      lex('<p>Foo<a>bar</a>baz</p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'Foo', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'baz', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end

  context 'void elements' do
    example 'lex a void element' do
      lex('<br />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'br', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    example 'lex a void element with an attribute' do
      lex('<br class="foo" />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'br', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end

  context 'elements with namespaces' do
    example 'lex an element with namespaces' do
      lex('<foo:p></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NS, 'foo', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
