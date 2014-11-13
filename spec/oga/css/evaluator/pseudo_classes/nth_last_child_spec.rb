require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':nth-last-child pseudo class' do
    before do
      @document = parse('<root><a1 /><a2 /><a3 /><a4 /></root>')

      @root = @document.children[0]
      @a1   = @root.children[0]
      @a2   = @root.children[1]
      @a3   = @root.children[2]
      @a4   = @root.children[3]
    end

    example 'return a node set containing the last child node' do
      evaluate_css(@document, 'root :nth-last-child(1)').should == node_set(@a4)
    end

    example 'return a node set containing even nodes' do
      evaluate_css(@document, 'root :nth-last-child(even)')
        .should == node_set(@a1, @a3)
    end

    example 'return a node set containing odd nodes' do
      evaluate_css(@document, 'root :nth-last-child(odd)')
        .should == node_set(@a2, @a4)
    end

    example 'return a node set containing every 2 nodes starting at node 3' do
      evaluate_css(@document, 'root :nth-last-child(2n+2)')
        .should == node_set(@a1, @a3)
    end

    example 'return a node set containing all nodes' do
      evaluate_css(@document, 'root :nth-last-child(n)')
        .should == @root.children
    end

    example 'return a node set containing the first two nodes' do
      evaluate_css(@document, 'root :nth-last-child(-n+2)')
        .should == node_set(@a3, @a4)
    end

    example 'return a node set containing all nodes starting at node 2' do
      evaluate_css(@document, 'root :nth-last-child(n+2)')
        .should == node_set(@a1, @a2, @a3)
    end
  end
end
