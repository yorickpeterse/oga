require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'elements' do
    it 'lexes an opening element' do
      lex('<p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1]
      ]
    end

    it 'lexes an opening element with a stray double quote' do
      lex('<p">').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1]
      ]
    end

    it 'lexes an opening element with a stray double quoted string' do
      lex('<p"">').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1]
      ]
    end

    it 'lexes an opening an closing element' do
      lex('<p></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an opening an closing element with a stray double quote' do
      lex('<p"></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an opening an closing element with a stray double quoted string' do
      lex('<p""></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a paragraph element with text inside it' do
      lex('<p>Hello</p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'Hello', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes text followed by a paragraph element' do
      lex('Foo<p>').should == [
        [:T_TEXT, 'Foo', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1]
      ]
    end

    it 'lexes an element with a newline in the open tag' do
      lex("<p\n></p>").should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 2]
      ]
    end

    it 'lexes an element with a carriage return in the open tag' do
      lex("<p\r></p>").should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 2]
      ]
    end
  end

  describe 'elements with attributes' do
    it 'lexes an element with an attribute without a value' do
      lex('<p foo></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an element with an empty attribute followed by a stray double quote' do
      lex('<p foo"></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an element with an attribute with an empty value' do
      lex('<p foo=""></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an attribute value followed by a stray double quote' do
      lex('<p foo="""></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an attribute value followed by a stray single quote' do
      lex('<p foo=""\'></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a paragraph element with attributes' do
      lex('<p class="foo">Hello</p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_TEXT, 'Hello', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a paragraph element with a newline in an attribute' do
      lex("<p class=\"\nfoo\">Hello</p>").should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, "\nfoo", 1],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_TEXT, 'Hello', 2],
        [:T_ELEM_END, nil, 2]
      ]
    end

    it 'lexes a paragraph element with single quoted attributes' do
      lex("<p class='foo'></p>").should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a paragraph element with a namespaced attribute' do
      lex('<p foo:bar="baz"></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR_NS, 'foo', 1],
        [:T_ATTR, 'bar', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'baz', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end

  describe 'nested elements' do
    it 'lexes a nested element' do
      lex('<p><a></a></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes nested elements and text nodes' do
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

  describe 'void elements' do
    it 'lexes a void element' do
      lex('<br />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'br', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes a void element with an attribute' do
      lex('<br class="foo" />').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'br', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    describe 'without a space before the closing tag' do
      it 'lexes a void element' do
        lex('<br/>').should == [
          [:T_ELEM_START, nil, 1],
          [:T_ELEM_NAME, 'br', 1],
          [:T_ELEM_END, nil, 1]
        ]
      end

      it 'lexes a void element with an attribute' do
        lex('<br class="foo"/>').should == [
          [:T_ELEM_START, nil, 1],
          [:T_ELEM_NAME, 'br', 1],
          [:T_ATTR, 'class', 1],
          [:T_STRING_DQUOTE, nil, 1],
          [:T_STRING_BODY, 'foo', 1],
          [:T_STRING_DQUOTE, nil, 1],
          [:T_ELEM_END, nil, 1]
        ]
      end
    end
  end

  describe 'elements with namespaces' do
    it 'lexes an element with namespaces' do
      lex('<foo:p></p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NS, 'foo', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an element with a start and end namespace' do
      lex('<foo:p></foo:p>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NS, 'foo', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
