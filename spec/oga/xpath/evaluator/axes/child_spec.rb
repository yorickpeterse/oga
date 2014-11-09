require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'child axis' do
    before do
      @document = parse('<a><b></b></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
    end

    example 'return a node set containing a direct child node' do
      evaluate_xpath(@document, 'child::a').should == node_set(@a1)
    end

    example 'return a node set containing a nested child node' do
      evaluate_xpath(@document, 'child::a/child::b').should == node_set(@b1)
    end

    example 'return an empty node set for non existing child nodes' do
      evaluate_xpath(@document, 'child::x').should == node_set
    end
  end
end
