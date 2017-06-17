require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'variables' do
    it 'lexes a variable reference' do
      expect(lex_xpath('$foo')).to eq([[:T_VAR, 'foo']])
    end
  end
end
