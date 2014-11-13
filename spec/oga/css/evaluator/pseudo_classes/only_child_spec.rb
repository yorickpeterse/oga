require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':only-child pseudo class' do
    before do
      @document = parse('<root><a><c /></a><b><c /></b></root>')

      @root = @document.children[0]
      @c1   = @root.children[0].children[0]
      @c2   = @root.children[1].children[0]
    end

    example 'return a node set containing <c> nodes' do
      evaluate_css(@document, 'root :only-child').should == node_set(@c1, @c2)
    end
  end
end
