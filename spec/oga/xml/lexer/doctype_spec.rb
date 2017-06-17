require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'doctypes' do
    it 'lexes the HTML5 doctype' do
      expect(lex('<!DOCTYPE html>')).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_END, nil, 1]
      ])
    end

    it 'lexes a doctype containing a newline before the doctype name' do
      expect(lex("<!DOCTYPE\nhtml>")).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 2],
        [:T_DOCTYPE_END, nil, 2]
      ])
    end

    it 'lexes a doctype with a public ID preceded by a newline' do
      expect(lex("<!DOCTYPE html\nPUBLIC>")).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_TYPE, 'PUBLIC', 2],
        [:T_DOCTYPE_END, nil, 2]
      ])
    end

    it 'lexes a doctype with a public and system ID' do
      expect(lex('<!DOCTYPE HTML PUBLIC "foobar" "baz">')).to eq([
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
      ])
    end

    it 'lexes a doctype with a public and system ID using single quotes' do
      expect(lex("<!DOCTYPE HTML PUBLIC 'foobar' 'baz'>")).to eq([
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
      ])
    end

    it 'lexes an inline doctype' do
      expect(lex('<!DOCTYPE html [<!ELEMENT foo>]>')).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, '<!ELEMENT foo>', 1],
        [:T_DOCTYPE_END, nil, 1]
      ])
    end

    it 'lexes an empty inline doctype' do
      expect(lex('<!DOCTYPE html []>')).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_END, nil, 1]
      ])
    end

    it 'lexes an inline doctype containing a newline' do
      expect(lex("<!DOCTYPE html [foo\n]>")).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, "foo\n", 1],
        [:T_DOCTYPE_END, nil, 2]
      ])
    end

    it 'lexes an inline doctype containing a trailing newline using an IO' do
      input = StringIO.new("<!DOCTYPE html [foo\n]>")

      expect(lex(input)).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, "foo\n", 1],
        [:T_DOCTYPE_END, nil, 2]
      ])
    end

    it 'lexes an inline doctype containing a leading newline using an IO' do
      input = StringIO.new("<!DOCTYPE html [\nfoo]>")

      expect(lex(input)).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, "\n", 1],
        [:T_DOCTYPE_INLINE, "foo", 2],
        [:T_DOCTYPE_END, nil, 2]
      ])
    end

    # Technically not valid, put in place to make sure that the Ragel rules are
    # not too greedy.
    it 'lexes an inline doftype followed by a system ID' do
      expect(lex('<!DOCTYPE html [<!ELEMENT foo>] "foo">')).to eq([
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_INLINE, '<!ELEMENT foo>', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_STRING_BODY, 'foo', 1],
        [:T_STRING_DQUOTE, nil, 1],
        [:T_DOCTYPE_END, nil, 1]
      ])
    end
  end
end
