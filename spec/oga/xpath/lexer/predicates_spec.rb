require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'predicates' do
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
        [:T_EQ, nil],
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

    example 'lex a predicate expression using the div operator' do
      lex_xpath('/div[@number=4 div 2]').should == [
        [:T_SLASH, nil],
        [:T_IDENT, 'div'],
        [:T_LBRACK, nil],
        [:T_AXIS, 'attribute'],
        [:T_IDENT, 'number'],
        [:T_EQ, nil],
        [:T_INT, 4],
        [:T_DIV, nil],
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
        [:T_EQ, nil],
        [:T_INT, 4],
        [:T_MUL, nil],
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
  end
end
