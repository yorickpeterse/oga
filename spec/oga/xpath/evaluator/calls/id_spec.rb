require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'id() function' do
    before do
      @document = parse('<root id="r1"><a id="a1"></a><a id="a2">a1</a></root>')

      @a1 = @document.children[0].children[0]
      @a2 = @document.children[0].children[1]
    end

    example 'return a node set containing the nodes with ID "a1"' do
      evaluate_xpath(@document, 'id("a1")').should == node_set(@a1)
    end

    example 'return a node set containing the nodes with ID "a1" or "a2"' do
      evaluate_xpath(@document, 'id("a1 a2")').should == node_set(@a1, @a2)
    end

    example 'return a node set containing the nodes with an ID based on a path' do
      evaluate_xpath(@document, 'id(root/a[2])').should == node_set(@a1)
    end
  end
end
