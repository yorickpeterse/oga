require 'spec_helper'

describe Oga::Lexer do
  context 'regular text' do
    example 'lex regular text' do
      lex('hello').should == [[:T_TEXT, 'hello', 1, 1]]
    end
  end

  context 'whitespace' do
    example 'lex regular whitespace' do
      lex(' ').should == [[:T_TEXT, ' ', 1, 1]]
    end

    example 'lex a newline' do
      lex("\n").should == [[:T_TEXT, "\n", 1, 1]]
    end

    example 'advance line numbers for newlines' do
      lex("\n ").should == [
        [:T_TEXT, "\n", 1, 1],
        [:T_TEXT, ' ', 2, 1]
      ]
    end
  end
end
