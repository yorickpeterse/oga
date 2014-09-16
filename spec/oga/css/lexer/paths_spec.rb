require 'spec_helper'

describe Oga::CSS::Lexer do
  context 'paths' do
    example 'lex a simple path' do
      lex_css('h3').should == [[:T_IDENT, 'h3']]
    end

    example 'lex a path with two members' do
      lex_css('div h3').should == [
        [:T_IDENT, 'div'],
        [:T_SPACE, nil],
        [:T_IDENT, 'h3']
      ]
    end
  end
end
