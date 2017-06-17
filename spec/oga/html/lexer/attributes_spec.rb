require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML attributes' do
    it 'lexes an attribute with an unquoted value' do
      expect(lex_html('<a href=foo></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with an unquoted value containing a space' do
      expect(lex_html('<a href=foo bar></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ATTR, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with an unquoted value containing an underscore' do
      expect(lex_html('<a href=foo_bar></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo_bar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with an unquoted value containing a dash' do
      expect(lex_html('<a href=foo-bar></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo-bar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with an unquoted value containing a slash' do
      expect(lex_html('<a href=foo/></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo/', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with an unquoted chunk of Javascript' do
      expect(lex_html('<a href=ijustlovehtml("because","reasons")')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'ijustlovehtml("because","reasons")', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with an unquoted chunk of Javascript followed by another attribute' do
      expect(lex_html('<a href=ijustlovehtml("because","reasons") foo="bar"')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'ijustlovehtml("because","reasons")', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'bar', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with a value without a starting double quote' do
      expect(lex_html('<a href=foo"></a>')).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo"', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an attribute with a value without a starting single quote' do
      expect(lex_html("<a href=foo'></a>")).to eq([
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, "foo'", 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with spaces around the attribute equal sign' do
      expect(lex_html('<p foo = "bar"></p>')).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'bar', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end

    it 'lexes an element with a newline following the equals sign' do
      expect(lex_html(%Q{<p foo =\n"bar"></p>})).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_STRING_BODY, 'bar', 2],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an element with a newline following the equals sign using an IO as input' do
      expect(lex_stringio(%Q{<p foo =\n"bar"></p>}, :html => true)).to eq([
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_STRING_BODY, 'bar', 2],
        [:T_STRING_DQUOTE, nil, 2],
        [:T_ELEM_END, nil, 2]
      ])
    end

    it 'lexes an element containing a namespaced attribute' do
      expect(lex_html('<foo bar:baz="10" />')).to eq([
        [:T_ELEM_NAME, 'foo', 1],
        [:T_ATTR, 'bar:baz', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, '10', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ])
    end
  end
end
