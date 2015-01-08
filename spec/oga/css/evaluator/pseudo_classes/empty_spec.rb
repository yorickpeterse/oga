require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':empty pseudo class' do
    before do
      @document = parse('<root><a></a><b>foo</b></root>')

      @a1 = @document.children[0].children[0]
      @b1 = @document.children[0].children[1]
    end

    it 'returns a node set containing empty nodes' do
      evaluate_css(@document, 'root :empty').should == node_set(@a1)
    end

    it 'returns a node set containing empty nodes with a node test' do
      evaluate_css(@document, 'root a:empty').should == node_set(@a1)
    end

    it 'returns an empty node set containing non empty nodes' do
      evaluate_css(@document, 'root b:empty').should == node_set
    end
  end
end
