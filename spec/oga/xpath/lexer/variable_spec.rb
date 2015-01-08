require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'variables' do
    it 'lexes a variable reference' do
      lex_xpath('$foo').should == [[:T_VAR, 'foo']]
    end
  end
end
