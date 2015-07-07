require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'node() tests' do
    before do
      @document = parse('<a><b>foo</b><!--foo--><![CDATA[bar]]></a>')

      @a1       = @document.children[0]
      @b1       = @a1.children[0]
      @comment1 = @a1.children[1]
      @cdata1   = @a1.children[2]
    end

    it 'returns a node set containing elements' do
      evaluate_xpath(@document, 'node()').should == node_set(@a1)
    end

    it 'returns a node set containing elements, comments and CDATA tags' do
      evaluate_xpath(@document, 'a/node()')
        .should == node_set(@b1, @comment1, @cdata1)
    end

    it 'returns a node set containing text nodes' do
      evaluate_xpath(@document, 'a/b/node()').should == node_set(@b1.children[0])
    end
  end
end
