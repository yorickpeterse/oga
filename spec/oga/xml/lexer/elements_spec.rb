# encoding: utf-8

require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'elements' do
    it 'lexes an opening element' do
      expect(lex('<p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an opening element with a stray double quote' do
      expect(lex('<p">')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an opening element with a stray double quoted string' do
      expect(lex('<p"">')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an opening an closing element' do
      expect(lex('<p></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an opening an closing element with a stray double quote' do
      expect(lex('<p"></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an opening an closing element with a stray double quoted string' do
      expect(lex('<p""></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a paragraph element with text inside it' do
      expect(lex('<p>Hello</p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'Hello', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes text followed by a paragraph element' do
      expect(lex('Foo<p>')).to eq([
        [:T_TEXT, 'Foo', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with a newline in the open tag' do
      expect(lex("<p\n></p>")).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an element with a carriage return in the open tag' do
      expect(lex("<p\r></p>")).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an element with a space in the closing tag' do
      expect(lex("<foo></foo >bar")).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'bar', 1]
      ])
    end

    it 'lexes an element with a newline in the closing tag' do
      expect(lex("<foo></foo\n>bar")).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'bar', 2]
      ])
    end

    it 'lexes an element with a newline in the closing tag using an IO as input' do
      expect(lex(StringIO.new("<foo></foo\n>bar"))).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'bar', 2]
      ])
    end
  end

  describe 'elements with attributes' do
    it 'lexes an element with an attribute without a value' do
      expect(lex('<p foo></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with an empty attribute followed by a stray double quote' do
      expect(lex('<p foo"></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with an attribute with an empty value' do
      expect(lex('<p foo=""></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute value followed by a stray double quote' do
      expect(lex('<p foo="""></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute value followed by a stray single quote' do
      expect(lex('<p foo=""\'></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a paragraph element with attributes' do
      expect(lex('<p class="foo">Hello</p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_TEXT, 'Hello', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a paragraph element with a newline in an attribute' do
      expect(lex("<p class=\"\nfoo\">Hello</p>")).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, "\nfoo", 1],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_TEXT, 'Hello', 2],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes a paragraph element with single quoted attributes' do
      expect(lex("<p class='foo'></p>")).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a paragraph element with a namespaced attribute' do
      expect(lex('<p foo:bar="baz"></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR_NS, 'foo', 1],
        [:T_ATTR, 'bar', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'baz', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with spaces around the attribute equal sign' do
      expect(lex('<p foo = "bar"></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'bar', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with a newline following the equals sign' do
      expect(lex(%Q{<p foo =\n"bar"></p>})).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_STRING_BODY, 'bar', 2],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an element with a newline following the equals sign using an IO as input' do
      expect(lex_stringio(%Q{<p foo =\n"bar"></p>})).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_STRING_BODY, 'bar', 2],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_ELEM_END, nil, 2]
      ])
    end
  end

  describe 'nested elements' do
    it 'lexes a nested element' do
      expect(lex('<p><a></a></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ELEM_END, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes nested elements and text nodes' do
      expect(lex('<p>Foo<a>bar</a>baz</p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_TEXT, 'Foo', 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_TEXT, 'bar', 1],
        [:T_ELEM_END, nil, 1],
        [:T_TEXT, 'baz', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end

  describe 'void elements' do
    it 'lexes a void element' do
      expect(lex('<br />')).to eq([
        [:T_ELEM_NAME, 'br', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes a void element with an attribute' do
      expect(lex('<br class="foo" />')).to eq([
        [:T_ELEM_NAME, 'br', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    describe 'without a space before the closing tag' do
      it 'lexes a void element' do
        expect(lex('<br/>')).to eq([
          [:T_ELEM_NAME, 'br', 1],
          [:T_ELEM_END, nil, 1]
        ])
      end

      it 'lexes a void element with an attribute' do
        expect(lex('<br class="foo"/>')).to eq([
          [:T_ELEM_NAME, 'br', 1],
          [:T_ATTR, 'class', 1],
          [:T_STRING_DQUOTE, nil, 1],
          [:T_STRING_BODY, 'foo', 1],
          [:T_STRING_DQUOTE, nil, 1],
          [:T_ELEM_END, nil, 1]
        ])
      end
    end
  end

  describe 'elements with namespaces' do
    it 'lexes an element with namespaces' do
      expect(lex('<foo:p></p>')).to eq([
        [:T_ELEM_NS, 'foo', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with a start and end namespace' do
      expect(lex('<foo:p></foo:p>')).to eq([
        [:T_ELEM_NS, 'foo', 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end

  it 'lexes an element with inline dots' do
    expect(lex('<SOAP..TestMapping..MappablePerson>')).to eq([
      [:T_ELEM_NAME, "SOAP..TestMapping..MappablePerson", 1],
      [:T_ELEM_END, nil, 1]
    ])
  end

  it 'lexes an element with a name containing Unicode characters' do
    expect(lex('<foobár />')).to eq([
      [:T_ELEM_NAME, 'foobár', 1],
      [:T_ELEM_END, nil, 1]
    ])
  end

  it 'lexes an element with a name containing an underscore' do
    expect(lex('<foo_bar />')).to eq([
      [:T_ELEM_NAME, 'foo_bar', 1],
      [:T_ELEM_END, nil, 1]
    ])
  end

  it 'lexes an element with a name containing a dash' do
    expect(lex('<foo-bar />')).to eq([
      [:T_ELEM_NAME, 'foo-bar', 1],
      [:T_ELEM_END, nil, 1]
    ])
  end

  it 'lexes an element with a name containing numbers' do
    expect(lex('<foo123 />')).to eq([
      [:T_ELEM_NAME, 'foo123', 1],
      [:T_ELEM_END, nil, 1]
    ])
  end
end
