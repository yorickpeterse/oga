require 'spec_helper'

describe Oga::XPath::Lexer do
  context 'node types' do
    example 'lex the "node" type' do
      lex_xpath('node()').should == [[:T_NODE_TYPE, 'node']]
    end

    example 'lex the "comment" type' do
      lex_xpath('comment()').should == [[:T_NODE_TYPE, 'comment']]
    end

    example 'lex the "text" type' do
      lex_xpath('text()').should == [[:T_NODE_TYPE, 'text']]
    end

    example 'lex the "processing-instruction" type' do
      lex_xpath('processing-instruction()').should == [
        [:T_NODE_TYPE, 'processing-instruction']
      ]
    end
  end
end
