require 'spec_helper'

describe Oga::XPath::Lexer do
  example 'lex a simple expression' do
    lex_xpath('/foo').should == [[:T_SLASH, nil], [:T_IDENT, 'foo']]
  end

  example 'lex a function call without arguments' do
    lex_xpath('count()').should == [
      [:T_IDENT, 'count'],
      [:T_LPAREN, nil],
      [:T_RPAREN, nil]
    ]
  end

  example 'lex a function call with a single argument' do
    lex_xpath('count(foo)').should == [
      [:T_IDENT, 'count'],
      [:T_LPAREN, nil],
      [:T_IDENT, 'foo'],
      [:T_RPAREN, nil]
    ]
  end

  example 'lex a function call with two arguments' do
    lex_xpath('count(foo, bar)').should == [
      [:T_IDENT, 'count'],
      [:T_LPAREN, nil],
      [:T_IDENT, 'foo'],
      [:T_COMMA, nil],
      [:T_IDENT, 'bar'],
      [:T_RPAREN, nil]
    ]
  end

  example 'lex a simple predicate expression' do
    lex_xpath('/foo[bar]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_LBRACK, nil],
      [:T_IDENT, 'bar'],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate that checks for equality' do
    lex_xpath('/foo[@bar="baz"]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_LBRACK, nil],
      [:T_AXIS, 'attribute'],
      [:T_IDENT, 'bar'],
      [:T_OP, '='],
      [:T_STRING, 'baz'],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate that user an integer' do
    lex_xpath('/foo[1]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_LBRACK, nil],
      [:T_INT, 1],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate that uses a float' do
    lex_xpath('/foo[1.5]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_LBRACK, nil],
      [:T_FLOAT, 1.5],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate using a function' do
    lex_xpath('/foo[bar()]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_LBRACK, nil],
      [:T_IDENT, 'bar'],
      [:T_LPAREN, nil],
      [:T_RPAREN, nil],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex an axis using the full syntax form' do
    lex_xpath('/parent::node()').should == [
      [:T_SLASH, nil],
      [:T_AXIS, 'parent'],
      [:T_IDENT, 'node'],
      [:T_LPAREN, nil],
      [:T_RPAREN, nil]
    ]
  end

  example 'lex an axis using the short syntax form' do
    lex_xpath('/..').should == [[:T_SLASH, nil], [:T_AXIS, 'parent']]
  end

  example 'lex a node test using a namespace' do
    lex_xpath('/foo:bar').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_COLON, nil],
      [:T_IDENT, 'bar']
    ]
  end
end
