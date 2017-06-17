# encoding: utf-8

require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'paths' do
    it 'lexes a simple path' do
      expect(lex_css('h3')).to eq([[:T_IDENT, 'h3']])
    end

    it 'lexes a path with Unicode characters' do
      expect(lex_css('áâã')).to eq([[:T_IDENT, 'áâã']])
    end

    it 'lexes a path with Unicode and ASCII characters' do
      expect(lex_css('áâãfoo')).to eq([[:T_IDENT, 'áâãfoo']])
    end

    it 'lexes a simple path starting with an underscore' do
      expect(lex_css('_h3')).to eq([[:T_IDENT, '_h3']])
    end

    it 'lexes a path with an escaped identifier' do
      expect(lex_css('foo\.bar\.baz')).to eq([[:T_IDENT, 'foo.bar.baz']])
    end

    it 'lexes a path with an escaped identifier followed by another identifier' do
      expect(lex_css('foo\.bar baz')).to eq([
        [:T_IDENT, 'foo.bar'],
        [:T_SPACE, nil],
        [:T_IDENT, 'baz']
      ])
    end

    it 'lexes a path with two members' do
      expect(lex_css('div h3')).to eq([
        [:T_IDENT, 'div'],
        [:T_SPACE, nil],
        [:T_IDENT, 'h3']
      ])
    end

    it 'lexes a path with two members separated by multiple spaces' do
      expect(lex_css('div    h3')).to eq([
        [:T_IDENT, 'div'],
        [:T_SPACE, nil],
        [:T_IDENT, 'h3']
      ])
    end

    it 'lexes two paths' do
      expect(lex_css('foo, bar')).to eq([
        [:T_IDENT, 'foo'],
        [:T_COMMA, nil],
        [:T_IDENT, 'bar']
      ])
    end

    it 'lexes a path selecting an ID' do
      expect(lex_css('#foo')).to eq([
        [:T_HASH, nil],
        [:T_IDENT, 'foo']
      ])
    end

    it 'lexes a path selecting a class' do
      expect(lex_css('.foo')).to eq([
        [:T_DOT, nil],
        [:T_IDENT, 'foo']
      ])
    end

    it 'lexes a wildcard path' do
      expect(lex_css('*')).to eq([[:T_IDENT, '*']])
    end
  end
end
