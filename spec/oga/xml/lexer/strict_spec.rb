require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'lexing XML using strict mode' do
    it 'does not automatically insert missing closing tags' do
      lex('<foo>bar', :strict => true).should == [
        [:T_ELEM_NAME, 'foo', 1],
        [:T_TEXT, 'bar', 1]
      ]
    end
  end
end
