require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'paths' do
    example 'lex a simple path' do
      lex_css('h3').should == [[:T_IDENT, 'h3']]
    end

    example 'lex a path with two members' do
      lex_css('div h3').should == [
        [:T_IDENT, 'div'],
        [:T_IDENT, 'h3']
      ]
    end

    example 'lex two paths' do
      lex_css('foo, bar').should == [
        [:T_IDENT, 'foo'],
        [:T_COMMA, nil],
        [:T_IDENT, 'bar']
      ]
    end

    example 'lex a path selecting an ID' do
      lex_css('#foo').should == [
        [:T_HASH, nil],
        [:T_IDENT, 'foo']
      ]
    end

    example 'lex a path selecting a class' do
      lex_css('.foo').should == [
        [:T_DOT, nil],
        [:T_IDENT, 'foo']
      ]
    end

    example 'lex a wildcard path' do
      lex_css('*').should == [[:T_IDENT, '*']]
    end

    example 'lex a path containing a namespace name' do
      lex_css('foo|bar').should == [
        [:T_IDENT, 'foo'],
        [:T_PIPE, nil],
        [:T_IDENT, 'bar']
      ]
    end

    example 'lex a path containing a namespace wildcard' do
      lex_css('*|foo').should == [
        [:T_IDENT, '*'],
        [:T_PIPE, nil],
        [:T_IDENT, 'foo']
      ]
    end

    example 'lex a path containing a simple predicate' do
      lex_css('foo[bar]').should == [
        [:T_IDENT, 'foo'],
        [:T_LBRACK, nil],
        [:T_IDENT, 'bar'],
        [:T_RBRACK, nil]
      ]
    end
  end
end
