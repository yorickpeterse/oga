require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'variables' do
    example 'lex a variable reference' do
      lex_xpath('$foo').should == [[:T_VAR, 'foo']]
    end
  end
end
