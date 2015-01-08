require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'self axis' do
    before do
      @document = parse('<a><b>foo</b><b>bar<c>test</c></b></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
      @b2 = @a1.children[1]
    end

    it 'returns a node set containing the context node' do
      evaluate_xpath(@document, 'a/self::a').should == node_set(@a1)
    end

    it 'returns an empty node set for non existing nodes' do
      evaluate_xpath(@document, 'a/self::b').should == node_set
    end

    it 'returns a node set containing the context node using the short form' do
      evaluate_xpath(@document, 'a/.').should == node_set(@a1)
    end

    it 'returns a node set by matching the text of a node' do
      evaluate_xpath(@document, 'a/b[. = "foo"]').should == node_set(@b1)
    end

    it 'returns a node set by matching the text of a path' do
      evaluate_xpath(@document, 'a/b[c/. = "test"]').should == node_set(@b2)
    end

    it 'returns a node set by matching the text of a nested predicate' do
      evaluate_xpath(@document, 'a/b[c[. = "test"]]').should == node_set(@b2)
    end

    it 'returns a node set containing the document itself' do
      evaluate_xpath(@document, 'self::node()').should == node_set(@document)
    end
  end
end
