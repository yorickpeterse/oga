require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':nth-child pseudo class' do
    before do
      @document = parse('<root><a1 /><a2 /><a3 /><a4 /></root>')

      @root = @document.children[0]
      @a1   = @root.children[0]
      @a2   = @root.children[1]
      @a3   = @root.children[2]
      @a4   = @root.children[3]
    end

    it 'returns a node set containing the first child node' do
      expect(evaluate_css(@document, 'root :nth-child(1)')).to eq(node_set(@a1))
    end

    it 'returns a node set containing even nodes' do
      expect(evaluate_css(@document, 'root :nth-child(even)'))
        .to eq(node_set(@a2, @a4))
    end

    it 'returns a node set containing odd nodes' do
      expect(evaluate_css(@document, 'root :nth-child(odd)'))
        .to eq(node_set(@a1, @a3))
    end

    it 'returns a node set containing every 2 nodes starting at node 2' do
      expect(evaluate_css(@document, 'root :nth-child(2n+2)'))
        .to eq(node_set(@a2, @a4))
    end

    it 'returns a node set containing all nodes' do
      expect(evaluate_css(@document, 'root :nth-child(n)')).to eq(@root.children)
    end

    it 'returns a node set containing the first two nodes' do
      expect(evaluate_css(@document, 'root :nth-child(-n+2)'))
        .to eq(node_set(@a1, @a2))
    end

    it 'returns a node set containing all nodes starting at node 2' do
      expect(evaluate_css(@document, 'root :nth-child(n+2)'))
        .to eq(node_set(@a2, @a3, @a4))
    end
  end
end
