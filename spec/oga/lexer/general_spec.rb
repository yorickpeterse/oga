require 'spec_helper'

describe Oga::Lexer do
  context 'regular text' do
    example 'lex regular text' do
      lex('hello').should == [[:T_TEXT, 'hello', 1, 1]]
    end
  end

  context 'whitespace' do
    example 'lex regular whitespace' do
      lex(' ').should == [[:T_SPACE, ' ', 1, 1]]
    end

    example 'lex a newline' do
      lex("\n").should == [[:T_NEWLINE, "\n", 1, 1]]
    end

    example 'advance column numbers for spaces' do
      lex('  ').should == [
        [:T_SPACE, ' ', 1, 1],
        [:T_SPACE, ' ', 1, 2]
      ]
    end

    example 'advance line numbers for newlines' do
      lex("\n ").should == [
        [:T_NEWLINE, "\n", 1, 1],
        [:T_SPACE, ' ', 2, 1]
      ]
    end
  end
end
