require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'full axes' do
    it 'lexes the ancestor axis' do
      expect(lex_xpath('/ancestor::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'ancestor'],
        [:T_IDENT, 'A']
      ])
    end

    it 'lexes the ancestor-or-self axis' do
      expect(lex_xpath('/ancestor-or-self::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'ancestor-or-self'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the attribute axis' do
      expect(lex_xpath('/attribute::class')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'class'],
      ])
    end

    it 'lexes the child axis' do
      expect(lex_xpath('/child::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'child'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the descendant axis' do
      expect(lex_xpath('/descendant::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the descendant-or-self axis' do
      expect(lex_xpath('/descendant-or-self::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the following axis' do
      expect(lex_xpath('/following::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'following'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the following-sibling axis' do
      expect(lex_xpath('/following-sibling::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'following-sibling'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the namespace axis' do
      expect(lex_xpath('/namespace::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'namespace'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the parent axis' do
      expect(lex_xpath('/parent::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the preceding axis' do
      expect(lex_xpath('/preceding::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'preceding'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the preceding-sibling axis' do
      expect(lex_xpath('/preceding-sibling::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'preceding-sibling'],
        [:T_IDENT, 'A'],
      ])
    end

    it 'lexes the self axis' do
      expect(lex_xpath('/self::A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'self'],
        [:T_IDENT, 'A'],
      ])
    end
  end

  describe 'short axes' do
    it 'lexes the @attribute axis' do
      expect(lex_xpath('/@A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'A']
      ])
    end

    it 'lexes the // axis' do
      expect(lex_xpath('//A')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_TYPE_TEST, 'node'],
        [:T_SLASH, nil],
        [:T_IDENT, 'A']
      ])
    end

    it 'lexes the .. axis' do
      expect(lex_xpath('/..')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_TYPE_TEST, 'node']
      ])
    end

    it 'lexes the . axis' do
      expect(lex_xpath('/.')).to eq([
        [:T_SLASH, nil],
        [:T_AXIS, 'self'],
        [:T_TYPE_TEST, 'node']
      ])
    end

    it 'lexes the . axis followed by a path' do
      expect(lex_xpath('./foo')).to eq([
        [:T_AXIS, 'self'],
        [:T_TYPE_TEST, 'node'],
        [:T_SLASH, nil],
        [:T_IDENT, 'foo']
      ])
    end
  end
end
