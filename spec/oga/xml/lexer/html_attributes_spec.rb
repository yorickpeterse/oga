require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML attributes' do
    it 'lexes an attribute with an unquoted value' do
      lex_html('<a href=foo></a>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an attribute with an unquoted value containing a space' do
      lex_html('<a href=foo bar></a>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ATTR, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an attribute with an unquoted value containing an underscore' do
      lex_html('<a href=foo_bar></a>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo_bar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an attribute with an unquoted value containing a dash' do
      lex_html('<a href=foo-bar></a>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo-bar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end

    it 'lexes an attribute with an unquoted value containing a slash' do
      lex_html('<a href=foo/></a>').should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'a', 1],
        [:T_ATTR, 'href', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo/', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
