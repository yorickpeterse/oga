require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'paths' do
    example 'lex a simple path' do
      lex_css('h3').should == [[:T_IDENT, 'h3']]
    end

    example 'lex a simple path starting with an underscore' do
      lex_css('_h3').should == [[:T_IDENT, '_h3']]
    end

    example 'lex a path with two members' do
      lex_css('div h3').should == [
        [:T_IDENT, 'div'],
        [:T_SPACE, nil],
        [:T_IDENT, 'h3']
      ]
    end

    example 'lex a path with two members separated by multiple spaces' do
      lex_css('div    h3').should == [
        [:T_IDENT, 'div'],
        [:T_SPACE, nil],
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
  end
end
