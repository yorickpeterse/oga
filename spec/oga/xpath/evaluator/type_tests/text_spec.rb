require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'text() tests' do
    before do
      @document = parse('<a>foo<b>bar</b></a>')

      @text1 = @document.children[0].children[0]
      @text2 = @document.children[0].children[1].children[0]
    end

    it 'returns a node set containing text nodes' do
      evaluate_xpath(@document, 'a/text()').should == node_set(@text1)
    end

    it 'returns a node set containing nested text nodes' do
      evaluate_xpath(@document, 'a/b/text()').should == node_set(@text2)
    end
  end
end
