# encoding: utf-8

require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'general' do
    it 'lexes a simple expression' do
      expect(lex_xpath('/foo')).to eq([[:T_SLASH, nil], [:T_IDENT, 'foo']])
    end

    it 'lexes an expression using Unicode identifiers' do
      expect(lex_xpath('fóó')).to eq([[:T_IDENT, 'fóó']])
    end

    it 'lexes an expression using Unicode plus ASCII identifiers' do
      expect(lex_xpath('fóóbar')).to eq([[:T_IDENT, 'fóóbar']])
    end

    it 'lexes an expression using an identifier with a dot' do
      expect(lex_xpath('foo.bar')).to eq([[:T_IDENT, 'foo.bar']])
    end

    it 'lexes a simple expression with a test starting with an underscore' do
      expect(lex_xpath('/_foo')).to eq([[:T_SLASH, nil], [:T_IDENT, '_foo']])
    end

    it 'lexes a node test using a namespace' do
      expect(lex_xpath('/foo:bar')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'foo'],
        [:T_COLON, nil],
        [:T_IDENT, 'bar']
      ])
    end

    it 'lexes a whildcard node test' do
      expect(lex_xpath('/*')).to eq([[:T_SLASH, nil], [:T_IDENT, '*']])
    end

    it 'lexes a wildcard node test for a namespace' do
      expect(lex_xpath('/*:foo')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, '*'],
        [:T_COLON, nil],
        [:T_IDENT, 'foo']
      ])
    end

    # The following are a bunch of examples taken from Wikipedia and the W3
    # spec to see how the lexer handles them.

    it 'lexes an descendant-or-self expression' do
      expect(lex_xpath('/wikimedia//editions')).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'wikimedia'],
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_TYPE_TEST, 'node'],
        [:T_SLASH, nil],
        [:T_IDENT, 'editions']
      ])
    end

    it 'lexes a complex expression using predicates and function calls' do
      path = '/wikimedia/projects/project[@name="Wikipedia"]/editions/edition/text()'

      expect(lex_xpath(path)).to eq([
        [:T_SLASH, nil],
        [:T_IDENT, 'wikimedia'],
        [:T_SLASH, nil],
        [:T_IDENT, 'projects'],
        [:T_SLASH, nil],
        [:T_IDENT, 'project'],
        [:T_LBRACK, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'name'],
        [:T_EQ, nil],
        [:T_STRING, 'Wikipedia'],
        [:T_RBRACK, nil],
        [:T_SLASH, nil],
        [:T_IDENT, 'editions'],
        [:T_SLASH, nil],
        [:T_IDENT, 'edition'],
        [:T_SLASH, nil],
        [:T_TYPE_TEST, 'text']
      ])
    end
  end
end
