require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'HTML elements' do
    it 'lexes an element containing an element namespace' do
      lex_html('<foo:bar />').should == [
        [:T_ELEM_NAME, 'bar', 1],
        [:T_ELEM_END, nil, 1]
      ]
    end
  end
end
