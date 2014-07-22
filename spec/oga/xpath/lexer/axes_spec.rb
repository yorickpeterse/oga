require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'full axes' do
    example 'lex the ancestor axis' do
      lex_xpath('/ancestor::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'ancestor'],
        [:T_IDENT, 'A']
      ]
    end

    example 'lex the ancestor-or-self axis' do
      lex_xpath('/ancestor-or-self::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'ancestor-or-self'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the attribute axis' do
      lex_xpath('/attribute::class').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'class'],
      ]
    end

    example 'lex the child axis' do
      lex_xpath('/child::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'child'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the descendant axis' do
      lex_xpath('/descendant::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the descendant-or-self axis' do
      lex_xpath('/descendant-or-self::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the following axis' do
      lex_xpath('/following::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'following'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the following-sibling axis' do
      lex_xpath('/following-sibling::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'following-sibling'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the namespace axis' do
      lex_xpath('/namespace::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'namespace'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the parent axis' do
      lex_xpath('/parent::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the preceding axis' do
      lex_xpath('/preceding::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'preceding'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the preceding-sibling axis' do
      lex_xpath('/preceding-sibling::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'preceding-sibling'],
        [:T_IDENT, 'A'],
      ]
    end

    example 'lex the self axis' do
      lex_xpath('/self::A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'self'],
        [:T_IDENT, 'A'],
      ]
    end
  end

  context 'short axes' do
    example 'lex the @attribute axis' do
      lex_xpath('/@A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'A']
      ]
    end

    example 'lex the // axis' do
      lex_xpath('//A').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_IDENT, 'node'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil],
        [:T_SLASH, nil],
        [:T_IDENT, 'A']
      ]
    end

    example 'lex the .. axis' do
      lex_xpath('/..').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'parent'],
        [:T_IDENT, 'node'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil],
      ]
    end

    example 'lex the . axis' do
      lex_xpath('/.').should == [
        [:T_SLASH, nil],
        [:T_AXIS, 'self'],
        [:T_IDENT, 'node'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil],
      ]
    end
  end
end
