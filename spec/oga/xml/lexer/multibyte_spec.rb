# encoding: utf-8

require 'spec_helper'

describe Oga::XML::Lexer do
  describe 'multibyte text nodes' do
    it 'lexes a multibyte text node' do
      expect(lex('쿠키')).to eq([[:T_TEXT, '쿠키', 1]])
    end
  end
end
