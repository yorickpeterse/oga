require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'general' do
    example 'lex a simple expression' do
      lex_xpath('/foo').should == [[:T_SLASH, nil], [:T_IDENT, 'foo']]
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
      lex_xpath('/*').should == [[:T_SLASH, nil], [:T_IDENT, '*']]
    end

    example 'lex a wildcard node test for a namespace' do
      lex_xpath('/*:foo').should == [
        [:T_SLASH, nil],
        [:T_IDENT, '*'],
        [:T_COLON, nil],
        [:T_IDENT, 'foo']
      ]
    end

    # The following are a bunch of examples taken from Wikipedia and the W3
    # spec to see how the lexer handles them.

    example 'lex an descendant-or-self expression' do
      lex_xpath('/wikimedia//editions').should == [
        [:T_SLASH, nil],
        [:T_IDENT, 'wikimedia'],
        [:T_SLASH, nil],
        [:T_AXIS, 'descendant-or-self'],
        [:T_IDENT, 'node'],
        [:T_LPAREN, nil],
        [:T_RPAREN, nil],
        [:T_SLASH, nil],
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
        [:T_EQ, nil],
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
end
