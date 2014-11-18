require 'spec_helper'

describe Oga::XML::Lexer do
  context 'doctypes' do
    example 'lex the HTML5 doctype' do
      lex('<!DOCTYPE html>').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex a doctype with a public and system ID' do
      lex('<!DOCTYPE HTML PUBLIC "foobar" "baz">').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'HTML', 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foobar', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'baz', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex a doctype with a public and system ID using single quotes' do
      lex("<!DOCTYPE HTML PUBLIC 'foobar' 'baz'>").should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'HTML', 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'foobar', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_STRING_BODY, 'baz', 1],
        [:T_STRING_SQUOTE, nil, 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex an inline doctype' do
      lex('<!DOCTYPE html [<!ELEMENT foo>]>').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, '<!ELEMENT foo>', 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex an empty inline doctype' do
      lex('<!DOCTYPE html []>').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end

    example 'lex an inline doctype containing a newline' do
      lex("<!DOCTYPE html [foo\n]>").should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, "foo\n", 1],
        [:T_DOCTYPE_END, nil, 2]
      ]
    end

    example 'lex an inline doctype containing a trailing newline using an IO' do
      input = StringIO.new("<!DOCTYPE html [foo\n]>")

      lex(input).should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, "foo\n", 1],
        [:T_DOCTYPE_END, nil, 2]
      ]
    end

    example 'lex an inline doctype containing a leading newline using an IO' do
      input = StringIO.new("<!DOCTYPE html [\nfoo]>")

      lex(input).should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, "\n", 1],
        [:T_DOCTYPE_INLINE, "foo", 2],
        [:T_DOCTYPE_END, nil, 2]
      ]
    end

    # Technically not valid, put in place to make sure that the Ragel rules are
    # not too greedy.
    example 'lex an inline doftype followed by a system ID' do
      lex('<!DOCTYPE html [<!ELEMENT foo>] "foo">').should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, '<!ELEMENT foo>', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_DOCTYPE_END, nil, 1]
      ]
    end
  end
end
