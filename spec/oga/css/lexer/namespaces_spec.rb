require 'spec_helper'

describe Oga::CSS::Lexer do
  describe 'namespaces' do
    it 'lexes a path containing a namespace name' do
      expect(lex_css('foo|bar')).to eq([
        [:T_IDENT, 'foo'],
        [:T_PIPE, nil],
        [:T_IDENT, 'bar']
      ])
    end

    it 'lexes a path containing a namespace wildcard' do
      expect(lex_css('*|foo')).to eq([
        [:T_IDENT, '*'],
        [:T_PIPE, nil],
        [:T_IDENT, 'foo']
      ])
    end
  end
end
