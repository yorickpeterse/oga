require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':first-child pseudo class' do
    before do
      @document = parse('<root><a /><b /></root>')

      @a1 = @document.children[0].children[0]
      @b1 = @document.children[0].children[1]
    end

    example 'return a node set containing the first child node' do
      evaluate_css(@document, 'root :first-child').should == node_set(@a1)
    end

    example 'return a node set containing the first child node with a node test' do
      evaluate_css(@document, 'root a:first-child').should == node_set(@a1)
    end

    example 'return an empty node set for non first-child nodes' do
      evaluate_css(@document, 'root b:first-child').should == node_set
    end
  end
end
