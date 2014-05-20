require 'spec_helper'

describe Oga::XML::Lexer do
  context 'regular text' do
    example 'lex regular text' do
      lex('hello').should == [[:T_TEXT, 'hello', 1]]
    end

    example 'lex regular whitespace' do
      lex(' ').should == [[:T_TEXT, ' ', 1]]
    end

    example 'lex a newline' do
      lex("\n").should == [[:T_TEXT, "\n", 1]]
    end

    example 'lex text followed by a newline' do
      lex("foo\n").should == [[:T_TEXT, "foo\n", 1]]
    end

    example 'lex a > as regular text' do
      lex('>').should == [[:T_TEXT, '>', 1]]
    end
  end
end
