require 'spec_helper'

describe Oga::XML::Lexer do
  context 'IO as input' do
    example 'lex a paragraph element with attributes' do
      io = StringIO.new("<p class='foo'>\nHello</p>")

      lex(io).should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'p', 1],
        [:T_ATTR, 'class', 1],
        [:T_STRING, 'foo', 1],
        [:T_TEXT, "\n", 1],
        [:T_TEXT, 'Hello', 2],
        [:T_ELEM_END, nil, 2]
      ]
    end
  end
end
