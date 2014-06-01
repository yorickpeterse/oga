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

  example 'lex a whildcard node test' do
    lex_xpath('/*').should == [[:T_SLASH, nil], [:T_STAR, nil]]
  end

  example 'lex a wildcard node test for a namespace' do
    lex_xpath('/*:foo').should == [
      [:T_SLASH, nil],
      [:T_STAR, nil],
      [:T_COLON, nil],
      [:T_IDENT, 'foo']
    ]
  end

  example 'lex a predicate expression using the div operator' do
    lex_xpath('/div[@number=4 div 2]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'div'],
      [:T_LBRACK, nil],
      [:T_AXIS, 'attribute'],
      [:T_IDENT, 'number'],
      [:T_OP, '='],
      [:T_INT, 4],
      [:T_OP, 'div'],
      [:T_INT, 2],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate expression using the * operator' do
    lex_xpath('/div[@number=4 * 2]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'div'],
      [:T_LBRACK, nil],
      [:T_AXIS, 'attribute'],
      [:T_IDENT, 'number'],
      [:T_OP, '='],
      [:T_INT, 4],
      [:T_OP, '*'],
      [:T_INT, 2],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate expression using axes' do
    lex_xpath('/div[/foo/bar]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'div'],
      [:T_LBRACK, nil],
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_SLASH, nil],
      [:T_IDENT, 'bar'],
      [:T_RBRACK, nil]
    ]
  end

  example 'lex a predicate expression using a wildcard' do
    lex_xpath('/div[/foo/*]').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'div'],
      [:T_LBRACK, nil],
      [:T_SLASH, nil],
      [:T_IDENT, 'foo'],
      [:T_SLASH, nil],
      [:T_STAR, nil],
      [:T_RBRACK, nil]
    ]
  end

  # The following are a bunch of examples taken from Wikipedia and the W3 spec
  # to see how the lexer handles them.

  example 'lex an descendant-or-self expression' do
    lex_xpath('/wikimedia//editions').should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'wikimedia'],
      [:T_SLASH, nil],
      [:T_AXIS, 'descendant-or-self'],
      [:T_IDENT, 'editions']
    ]
  end

  example 'lex a complex expression using predicates and function calls' do
    path = '/wikimedia/projects/project[@name="Wikipedia"]/editions/edition/text()'

    lex_xpath(path).should == [
      [:T_SLASH, nil],
      [:T_IDENT, 'wikimedia'],
      [:T_SLASH, nil],
      [:T_IDENT, 'projects'],
      [:T_SLASH, nil],
      [:T_IDENT, 'project'],
      [:T_LBRACK, nil],
      [:T_AXIS, 'attribute'],
      [:T_IDENT, 'name'],
      [:T_OP, '='],
      [:T_STRING, 'Wikipedia'],
      [:T_RBRACK, nil],
      [:T_SLASH, nil],
      [:T_IDENT, 'editions'],
      [:T_SLASH, nil],
      [:T_IDENT, 'edition'],
      [:T_SLASH, nil],
      [:T_IDENT, 'text'],
      [:T_LPAREN, nil],
      [:T_RPAREN, nil]
    ]
  end
end
