require 'spec_helper'

describe Oga::XPath::Lexer do
  describe 'node types' do
    it 'lexes the "node" type' do
      lex_xpath('node()').should == [[:T_TYPE_TEST, 'node']]
    end

    it 'lexes the "comment" type' do
      lex_xpath('comment()').should == [[:T_TYPE_TEST, 'comment']]
    end

    it 'lexes the "text" type' do
      lex_xpath('text()').should == [[:T_TYPE_TEST, 'text']]
    end

    it 'lexes the "processing-instruction" type' do
      lex_xpath('processing-instruction()').should == [
        [:T_TYPE_TEST, 'processing-instruction']
      ]
    end
  end
end
