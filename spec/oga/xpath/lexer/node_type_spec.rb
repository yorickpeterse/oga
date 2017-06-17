require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'node types' do
    it 'lexes the "node" type' do
      expect(lex_xpath('node()')).to eq([[:T_TYPE_TEST, 'node']])
    end

    it 'lexes the "comment" type' do
      expect(lex_xpath('comment()')).to eq([[:T_TYPE_TEST, 'comment']])
    end

    it 'lexes the "text" type' do
      expect(lex_xpath('text()')).to eq([[:T_TYPE_TEST, 'text']])
    end

    it 'lexes the "processing-instruction" type' do
      expect(lex_xpath('processing-instruction()')).to eq([
        [:T_TYPE_TEST, 'processing-instruction']
      ])
    end
  end
end
