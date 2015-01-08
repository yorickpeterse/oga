require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'full axes' do
    it 'lexes the ancestor axis' do
      lex_xpath('/ancestor::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'ancestor'],
        [:T_IDENT, 'A']
      ]
    end

    it 'lexes the ancestor-or-self axis' do
      lex_xpath('/ancestor-or-self::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'ancestor-or-self'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the attribute axis' do
      lex_xpath('/attribute::class').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'class'],
      ]
    end

    it 'lexes the child axis' do
      lex_xpath('/child::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'child'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the descendant axis' do
      lex_xpath('/descendant::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the descendant-or-self axis' do
      lex_xpath('/descendant-or-self::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the following axis' do
      lex_xpath('/following::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'following'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the following-sibling axis' do
      lex_xpath('/following-sibling::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'following-sibling'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the namespace axis' do
      lex_xpath('/namespace::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'namespace'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the parent axis' do
      lex_xpath('/parent::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the preceding axis' do
      lex_xpath('/preceding::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'preceding'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the preceding-sibling axis' do
      lex_xpath('/preceding-sibling::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'preceding-sibling'],
        [:T_IDENT, 'A'],
      ]
    end

    it 'lexes the self axis' do
      lex_xpath('/self::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'self'],
        [:T_IDENT, 'A'],
      ]
    end
  end

  describe 'short axes' do
    it 'lexes the @attribute axis' do
      lex_xpath('/@A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'A']
      ]
    end

    it 'lexes the // axis' do
      lex_xpath('//A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_TYPE_TEST, 'node'],
        [:T_SLASH, nil],
        [:T_IDENT, 'A']
      ]
    end

    it 'lexes the .. axis' do
      lex_xpath('/..').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_TYPE_TEST, 'node']
      ]
    end

    it 'lexes the . axis' do
      lex_xpath('/.').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'self'],
        [:T_TYPE_TEST, 'node']
      ]
    end

    it 'lexes the . axis followed by a path' do
      lex_xpath('./foo').should == [
        [:T_AXIS, 'self'],
        [:T_TYPE_TEST, 'node'],
        [:T_SLASH, nil],
        [:T_IDENT, 'foo']
      ]
    end
  end
end
